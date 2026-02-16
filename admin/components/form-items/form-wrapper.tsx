import { ReactNode } from "react";
import { UseFormReturn } from "react-hook-form";
import { Form } from "@/components/ui/form";

interface FormWrapperProps {
    children: ReactNode;
    form: UseFormReturn<any>;
    onSubmit?: (values: any) => void;
    className?: string;
}

const FormWrapper: React.FC<FormWrapperProps> = ({
    form,
    children,
    onSubmit,
    className = "",
}) => {
    const handleSubmit = onSubmit ? form.handleSubmit(onSubmit) : undefined;

    return (
        <Form {...form}>
            <form onSubmit={handleSubmit} className={`space-y-6 ${className}`}>
                {children}
            </form>
        </Form>
    );
};

export default FormWrapper;
