/** @format */

import React from "react";
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

interface Option {
    id?: string | number;
    name?: string;
    value: string;
    isSelected?: boolean;
}

interface SelectFormItemProps {
    label?: string | React.ReactNode;
    name: string | (number | string)[];
    showValueAsLabel?: boolean;
    isRequired?: boolean;
    isDisabled?: boolean;
    isReadOnly?: boolean;
    placeholder?: string;
    onChange?: (value: string) => void;
    options?: Option[];
    initialValue?: any;
    value?: any;
    span?: number;
    suffix?: string | React.ReactNode;
    mode?: "multiple" | "tags";
    notFoundContent?: React.ReactNode;
    onClear?: () => void;
    restField?: any;
    height?: number;
    error?: string;
}

const SelectFormItem: React.FC<SelectFormItemProps> = ({
    label = "",
    name,
    showValueAsLabel = false,
    isRequired = false,
    isDisabled = false,
    isReadOnly = false,
    placeholder,
    onChange = undefined,
    options,
    initialValue,
    value,
    span = 8,
    mode = null,
    suffix,
    notFoundContent,
    onClear = () => { },
    restField = null,
    height = null,
    error,
}) => {
    const defaultValue = initialValue ?? options?.find((item) => item?.isSelected)?.id?.toString();

    return (
        <div className={cn("flex flex-col space-y-2")}>
            {label && (
                <Label
                    htmlFor={name.toString()}
                    className={cn(
                        "text-sm font-medium",
                        isRequired && "after:content-['*'] after:text-red-500 after:ml-1"
                    )}
                >
                    {label}
                </Label>
            )}
            <Select
                value={value?.toString() || defaultValue}
                onValueChange={onChange}
                disabled={isDisabled}
                name={name.toString()}
            >
                <SelectTrigger
                    className={cn(
                        "w-full",
                        height && `h-[${height}px]`,
                        error && "border-red-500"
                    )}
                >
                    <SelectValue placeholder={placeholder || `Select ${label}`} />
                </SelectTrigger>
                <SelectContent>
                    {options?.length ? (
                        options.map((item) => (
                            <SelectItem
                                key={item.id ?? item.value}
                                value={(item.id ?? item.value).toString()}
                            >
                                {showValueAsLabel ? item.value : (item.name ?? item.value)}
                            </SelectItem>
                        ))
                    ) : (
                        <div className="p-2 text-sm text-muted-foreground">
                            {notFoundContent || "No options available"}
                        </div>
                    )}
                </SelectContent>
            </Select>
            {error && (
                <p className="text-sm text-red-500">{error}</p>
            )}
            {isRequired && !error && (
                <p className="text-sm text-muted-foreground">This field is required</p>
            )}
        </div>
    );
};

export default SelectFormItem;
