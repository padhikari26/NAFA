import { IsEmail, IsNotEmpty, IsOptional, IsString, MinLength } from 'class-validator';

// export class RegisterDto {
//   @IsNotEmpty()
//   @IsString()
//   name: string;

//   @IsNotEmpty()
//   @IsEmail()
//   email: string;

//   @IsOptional()
//   @IsString()
//   phone?: string;

//   @IsOptional()
//   @IsString()
//   addressLine1?: string;

//   @IsOptional()
//   @IsString()
//   addressLine2?: string;

//   @IsOptional()
//   @IsString()
//   city?: string;

//   @IsOptional()
//   @IsString()
//   state?: string;

//   @IsOptional()
//   @IsString()
//   zipCode?: string;

//   @IsOptional()
//   @IsString()
//   country?: string;

//   @IsOptional()
//   @IsString()
//   photo?: string;

// }

//admin registration DTO
export class AdminRegisterDto {
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @IsNotEmpty()
  @MinLength(6)
  password: string;
}
