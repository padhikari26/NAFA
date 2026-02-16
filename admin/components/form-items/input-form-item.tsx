/** @format */

import React from "react";
import { cn } from "@/lib/utils";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";

interface InputFormItemProps {
    label?: string | React.ReactNode | null;
    name?: string;
    isRequired?: boolean;
    isEmail?: boolean;
    isPercentage?: boolean;
    isNumber?: boolean;
    isAspectValidator?: boolean;
    isReadOnly?: boolean;
    isDisabled?: boolean;
    isFourDigit?: boolean;
    className?: string;
    containerClassName?: string;

    type?:
    | "text"
    | "password"
    | "email"
    | "number"
    | "tel"
    | "url"
    | "search"
    | "date"
    | "textarea";

    suffix?: React.ReactNode | null;
    addonBefore?: React.ReactNode;
    placeholder?: string;
    onChange?: (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => void;
    span?: number; // For grid layout compatibility
    size?: "large" | "middle" | "small";
    restField?: any;
    initialValue?: any;
    isCompareValue?: any;
    value?: string;
    alertMessage?: string;
    validationMessage?: string;
    customRules?: any[];
    prefix?: React.ReactNode;
    error?: string;
}

// Simple validators to replace the antd ones
const validateEmail = (value: string): boolean => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(value);
};

const validateNumber = (value: string): boolean => {
    return !isNaN(Number(value)) && value.trim() !== "";
};

const validatePercentage = (value: string): boolean => {
    const num = Number(value);
    return !isNaN(num) && num >= 0 && num <= 100;
};

const validateFourDigits = (value: string): boolean => {
    return /^\d{4}$/.test(value);
};

const validateAspectRatio = (value: string): boolean => {
    // Simple aspect ratio validation (e.g., "16:9", "4:3")
    return /^\d+:\d+$/.test(value);
};

const EMPTY_VALIDATION_MESSAGE = "This field is required";
const EMAIL_VALIDATION_MESSAGE = "Please enter a valid email";

const InputFormItem: React.FC<InputFormItemProps> = ({
    label = null,
    name = "",
    isRequired = false,
    isEmail = false,
    isPercentage = false,
    isNumber = false,
    isAspectValidator = false,
    isReadOnly = false,
    isDisabled = false,
    isFourDigit = false,
    type = "text",
    suffix = null,
    addonBefore,
    placeholder,
    onChange = undefined,
    span = 8,
    size = "middle",
    restField = null,
    initialValue = null,
    isCompareValue = null,
    value = "",
    alertMessage,
    validationMessage = "",
    customRules = [],
    prefix = null,
    className,
    containerClassName,
    error,
}) => {
    const [internalValue, setInternalValue] = React.useState(value || initialValue || "");
    const [validationError, setValidationError] = React.useState<string>("");

    // Handle validation
    const validateField = (fieldValue: string) => {
        if (isRequired && !fieldValue.trim()) {
            return validationMessage || EMPTY_VALIDATION_MESSAGE;
        }

        if (isEmail && fieldValue && !validateEmail(fieldValue)) {
            return EMAIL_VALIDATION_MESSAGE;
        }

        if (isNumber && fieldValue && !validateNumber(fieldValue)) {
            return "Please enter a valid number";
        }

        if (isPercentage && fieldValue && !validatePercentage(fieldValue)) {
            return "Please enter a percentage between 0 and 100";
        }

        if (isFourDigit && fieldValue && !validateFourDigits(fieldValue)) {
            return "Please enter exactly 4 digits";
        }

        if (isAspectValidator && fieldValue && !validateAspectRatio(fieldValue)) {
            return "Please enter a valid aspect ratio (e.g., 16:9)";
        }

        return "";
    };

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const newValue = e.target.value;
        setInternalValue(newValue);

        // Validate on change
        const error = validateField(newValue);
        setValidationError(error);

        if (onChange) {
            onChange(e);
        }
    };

    const handleBlur = () => {
        const error = validateField(internalValue);
        setValidationError(error);
    };

    // Grid-like styling for span compatibility
    const gridStyles = {
        width: span ? `${(span / 24) * 100}%` : "100%",
    };

    const inputProps = {
        name,
        value: value !== undefined ? value : internalValue,
        onChange: handleChange,
        onBlur: handleBlur,
        placeholder: placeholder || (typeof label === "string" ? label : ""),
        disabled: isDisabled,
        readOnly: isReadOnly,
        className: cn(
            size === "large" && "h-12 text-base",
            size === "small" && "h-8 text-sm",
            className
        ),
        type: type === "textarea" ? undefined : type,
        ...restField,
    };

    return (
        <div
            className={cn("flex flex-col space-y-2", containerClassName)}
            style={gridStyles}
        >
            {label && (
                <Label className="text-sm font-medium">
                    {label}
                    {isRequired && <span className="text-destructive ml-1">*</span>}
                    {alertMessage && (
                        <span className="text-destructive text-xs ml-2">{alertMessage}</span>
                    )}
                </Label>
            )}

            <div className="relative flex items-center">
                {addonBefore && (
                    <div className="px-3 py-2 border border-r-0 border-input bg-muted rounded-l-md text-sm">
                        {addonBefore}
                    </div>
                )}

                {prefix && (
                    <div className="absolute left-3 z-10 text-muted-foreground">
                        {prefix}
                    </div>
                )}

                {type === "textarea" ? (
                    <Textarea
                        {...inputProps}
                        className={cn(
                            prefix && "pl-8",
                            addonBefore && "rounded-l-none border-l-0",
                            suffix && "pr-8",
                            inputProps.className
                        )}
                    />
                ) : (
                    <Input
                        {...inputProps}
                        className={cn(
                            prefix && "pl-8",
                            addonBefore && "rounded-l-none border-l-0",
                            suffix && "pr-8",
                            inputProps.className
                        )}
                    />
                )}

                {suffix && (
                    <div className="absolute right-3 z-10 text-muted-foreground">
                        {suffix}
                    </div>
                )}
            </div>

            {(error || validationError) && (
                <p className="text-sm font-medium text-destructive">
                    {error || validationError}
                </p>
            )}
        </div>
    );
};

export default InputFormItem;
