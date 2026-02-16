import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class LoginDto {
  @IsString()
  @IsNotEmpty()
  loginCode: string;

  @IsNotEmpty()
  @IsString()
  name: string;

  @IsNotEmpty()
  @IsString()
  city?: string;

  @IsNotEmpty()
  @IsString()
  phone?: string;

  // @IsString()
  // @IsNotEmpty()
  // fcmToken: string;
}

export class CreateLoginCodeDto {
  @IsNotEmpty()
  @IsString()
  code: string;
}
