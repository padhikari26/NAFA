import { Controller, Post, Body, UseGuards, Get, Param, Put } from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateLoginCodeDto, LoginDto } from './dto/login.dto';

import { AdminLoginDto } from './dto/admin.login.dto';
import { Public } from '../common/decorators/public.decorator';
import { Role } from './schemas/user.schema';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { Roles } from 'src/common/decorators/roles.decorator';



@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService,
    //  private readonly uploadService: UploadService,
    // private readonly memberService: MemberService
  ) {

  }

  // @UseInterceptors(FileInterceptor('photo'))
  // @Post('register')
  // async register(@Body() registerDto: RegisterDto, @UploadedFile() photo?: Express.Multer.File) {
  //   try {
  //     // Pass photo file to service, let service handle upload and user creation
  //     const updatedUser = await this.authService.register(registerDto, photo);
  //     return updatedUser;
  //   } catch (error) {
  //     throw error;
  //   }
  // }
  @Public()
  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  // @Public()
  // @Post('admin/register')
  // async adminRegister(@Body() adminRegisterDto: AdminRegisterDto) {
  //   return this.authService.adminRegister(adminRegisterDto);
  // }

  @Public()
  @Post('admin/login')
  async adminLogin(@Body() loginDto: AdminLoginDto) {
    return this.authService.adminLogin(loginDto);
  }

  @UseGuards(JwtAuthGuard)
  @Roles(Role.ADMIN)
  @Put('admin/change-password/:id')
  async changePassword(@Param('id') id: string, @Body('newPassword') newPassword: string, @Body('currentPassword') currentPassword: string) {
    return this.authService.changePassword(id, newPassword, currentPassword);
  }

  @UseGuards(JwtAuthGuard)
  @Roles(Role.ADMIN)
  @Post('logincode')
  async createLoginCode(@Body() createLoginCodeDto: CreateLoginCodeDto) {
    return this.authService.createLoginCode(createLoginCodeDto);
  }

  @UseGuards(JwtAuthGuard)
  @Roles(Role.ADMIN)
  @Get('logincode')
  async getLoginCode() {
    return this.authService.getLoginCode();
  }
}
