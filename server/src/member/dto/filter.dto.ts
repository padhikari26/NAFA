import { IsBoolean, IsOptional } from "class-validator";
import { FilterDto } from "src/common/dto/filter.dto";

export class MemberFilterDto extends FilterDto {
    @IsOptional()
    @IsBoolean()
    isVerified?: boolean;

    @IsOptional()
    @IsBoolean()
    isSubscribed?: boolean;
}

