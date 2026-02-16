import { ReactNode } from "react";
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogDescription,
    DialogTrigger,
} from "./ui/dialog";
import { Button } from "./ui/button";
import { Plus } from "lucide-react";

interface ModalDialogWrapperProps {
    open: boolean;
    setOpen: (open: boolean) => void;
    title: string | ReactNode;
    subTitle?: string;
    children: ReactNode;
    className?: string;
    onCloseHandler?: () => void;
}

const ModalDialogWrapper = ({
    open,
    setOpen,
    title,
    subTitle = "",
    children,
    className = "w-[85vw] h-[85vh] max-w-none overflow-hidden z-[101] flex flex-col p-4",
    onCloseHandler = () => { },
}: ModalDialogWrapperProps) => {
    return (
        <Dialog open={open} onOpenChange={(val) => { setOpen(val); if (!val) onCloseHandler(); }} modal={false}>
            {/* Custom overlay with high z-index to cover sidebar */}
            {open && (
                <div className="fixed inset-0 z-[100] bg-black bg-opacity-50"></div>
            )}
            <DialogContent className={className} onInteractOutside={e => e.preventDefault()}>
                <DialogHeader className="pl-6 shrink-0">
                    <DialogTitle className="text-lg">{title}</DialogTitle>
                    {subTitle && <DialogDescription className="text-sm text-muted-foreground">{subTitle}</DialogDescription>}
                </DialogHeader>
                <div className="flex-1 overflow-hidden min-h-0">
                    {children}
                </div>
            </DialogContent>
        </Dialog>
    );
};

export default ModalDialogWrapper;
