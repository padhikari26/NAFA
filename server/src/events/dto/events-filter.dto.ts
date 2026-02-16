import { IsBoolean, IsOptional } from "class-validator";
import { FilterDto } from "src/common/dto/filter.dto";

export class EventsFilterDto extends FilterDto {
    @IsOptional()
    @IsBoolean()
    isUpcoming?: boolean;
}
