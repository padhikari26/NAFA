import { Injectable, UnauthorizedException, ConflictException, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { Role, User, UserDocument } from './schemas/user.schema';
import { AdminRegisterDto } from './dto/register.dto';
import { CreateLoginCodeDto, LoginDto } from './dto/login.dto';
import { Admin, AdminDocument } from './schemas/admin.schema';
import { AdminLoginDto } from './dto/admin.login.dto';
import { LoginCode, LoginCodeDocument } from './schemas/login-code.schema';

@Injectable()
export class AuthService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    @InjectModel(Admin.name) private adminModel: Model<AdminDocument>,
    @InjectModel(LoginCode.name) private loginCodeModel: Model<LoginCodeDocument>,
    private jwtService: JwtService,
  ) { }

  // async register(registerDto: RegisterDto, photo?: Express.Multer.File) {
  //   const { email, ...userData } = registerDto;

  //   const existingUser = await this.userModel.findOne({ email });
  //   if (existingUser) {
  //     throw new ConflictException('User already exists');
  //   }

  //   // Handle photo upload if photo is provided
  //   let photoId: string | undefined;
  //   if (photo) {
  //     const options = {
  //       path: 'members',
  //       type: 'photo' as const,
  //       multiple: false,
  //       formField: 'photo',
  //     };
  //     // Use UploadService to upload photo
  //     // You may need to inject UploadService in AuthService constructor
  //     if (!this['uploadService']) {
  //       throw new Error('UploadService not injected in AuthService');
  //     }
  //     const uploadResult = await this['uploadService'].uploadFiles([photo], options);
  //     if (uploadResult.files.length > 0) {
  //       photoId = uploadResult.files[0].id;
  //     } else {
  //       throw new Error('Photo upload failed - no image ID returned');
  //     }
  //   }

  //   const user = new this.userModel({
  //     email,
  //     ...userData,
  //     ...(photoId ? { photo: photoId } : {}),
  //   });

  //   await user.save();

  //   return {
  //     user: {
  //       id: user._id,
  //       // email: user.email,
  //       name: user.name,
  //       role: user.role,
  //       ...(photoId ? { photo: photoId } : {}),
  //     },
  //   };
  // }


  async login(loginDto: LoginDto) {
    const { loginCode, phone, name, city } = loginDto;

    // Check if loginCode matches or not
    const existingLoginCode = await this.loginCodeModel.findOne({ code: loginCode });
    if (!existingLoginCode) {
      throw new BadRequestException('Invalid authorization code');
    }

    let user = await this.userModel.findOne({ phone: phone });
    if (!user) {
      user = new this.userModel({ phone, name, city });
      await user.save();
    }

    user.lastLogin = new Date();
    await user.save();

    const payload = { sub: user._id, phone: user.phone, role: Role.USER, loginCode: existingLoginCode.code };
    const token = this.jwtService.sign(payload);
    return {
      user,
      token,
    };
  }

  async adminRegister(registerDto: AdminRegisterDto) {

    if (await this.adminModel.countDocuments() > 0) {
      throw new ConflictException('Admin already exists');
    }

    const { email, password } = registerDto;


    const existingAdmin = await this.adminModel.findOne({ email });
    if (existingAdmin) {
      throw new ConflictException('Admin already exists');
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const admin = new this.adminModel({
      email,
      password: hashedPassword,
    });

    await admin.save();

    const payload = { sub: admin._id, role: Role.ADMIN, email: admin.email };
    const token = this.jwtService.sign(payload);

    return {
      user: {
        id: admin._id,
        email: admin.email,
        role: Role.ADMIN,
      },
      token,
    };
  }

  async adminLogin(loginDto: AdminLoginDto) {
    const { email, password } = loginDto;

    const admin = await this.adminModel.findOne({ email });
    if (!admin) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const isPasswordValid = await bcrypt.compare(password, admin.password);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const payload = { sub: admin._id, email: admin.email, role: Role.ADMIN };
    const token = this.jwtService.sign(payload, { expiresIn: '24h' });

    return {
      user: {
        id: admin._id,
        email: admin.email,
        role: Role.ADMIN,
      },
      token,
    };
  }

  async createLoginCode(createLoginCodeDto: CreateLoginCodeDto) {
    const { code } = createLoginCodeDto;

    // Remove all existing login codes
    await this.loginCodeModel.deleteMany({});

    // Create the new login code (there will always be only one)
    const loginCode = new this.loginCodeModel({ code });
    await loginCode.save();

    return {
      status: 'success',
      code: loginCode.code,
    };
  }

  async getLoginCode() {
    return this.loginCodeModel.findOne();
  }


  // Change password for admin
  async changePassword(adminId: string, newPassword: string, currentPassword: string) {
    const admin = await this.adminModel.findById(adminId);
    if (!admin) {
      throw new NotFoundException('Admin not found');
    }
    const isCurrentPasswordValid = await bcrypt.compare(currentPassword, admin.password);
    if (!isCurrentPasswordValid) {
      throw new BadRequestException('Current password is incorrect');
    }
    if (currentPassword === newPassword) {
      throw new BadRequestException('New password must be different from the current password');
    }


    const hashedPassword = await bcrypt.hash(newPassword, 10);
    admin.password = hashedPassword;
    await admin.save();

    return { message: 'Password changed successfully' };
  }
}
