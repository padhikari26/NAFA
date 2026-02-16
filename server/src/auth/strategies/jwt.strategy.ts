import { BadRequestException, Injectable, UnauthorizedException } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { PassportStrategy } from "@nestjs/passport";
import { ExtractJwt, Strategy } from "passport-jwt";
import { MemberService } from "src/member/member.service";
import { Role } from "../schemas/user.schema";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { Admin, AdminDocument } from "../schemas/admin.schema";
import { LoginCode, LoginCodeDocument } from "../schemas/login-code.schema";
import { WinstonLogger } from "../../common/logger/winston-logger.service";

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(

    private config: ConfigService,
    private memberService: MemberService,
    @InjectModel(Admin.name) private adminModel: Model<AdminDocument>,
    @InjectModel(LoginCode.name) private loginCodeModel: Model<LoginCodeDocument>,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: config.get<string>('JWT_SECRET')!,
    });
  }

  async validate(payload: { sub: string; phone?: string; role: string; loginCode?: string }) {
    if (payload.role === Role.ADMIN) {
      const admin = await this.adminModel.findById(payload.sub);
      if (!admin) {
        return null;
      }
      return {
        _id: admin._id,
        id: admin._id,
        role: Role.ADMIN,
      };
    }
    const existingLoginCode = await this.loginCodeModel.findOne({ code: payload.loginCode });
    if (!existingLoginCode) {
      throw new UnauthorizedException('Invalid authorization code');
    }
    const user = await this.memberService.findById(payload.sub);

    if (!user) {
      console.log('User not found');
      return null;
    }
    return user;
  }
}



