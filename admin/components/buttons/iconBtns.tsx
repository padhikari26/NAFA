/** @format */

"use client";

import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import {
    Tooltip,
    TooltipContent,
    TooltipProvider,
    TooltipTrigger,
} from "@/components/ui/tooltip";
import {
    Edit,
    Eye,
    History,
    Plus,
    RefreshCw,
    Search,
    Tag,
    Trash2,
    Upload,
} from "lucide-react";
import type React from "react";
import { useState } from "react";
import { toast } from "sonner";

interface BaseIconButtonProps {
    onClick?: (e?: any) => void;
    tooltip?: string;
    size?: "sm" | "default" | "lg" | "icon";
    disabled?: boolean;
    className?: string;
    icon?: React.ReactNode;
}
export const PopConfirmDeleteIconBtn: React.FC<
    BaseIconButtonProps & { onConfirm: () => void; loading?: boolean }
> = ({
    onConfirm,
    tooltip = "Delete",
    size = "icon",
    disabled = false,
    loading = false,
    className,
}) => {
        const [open, setOpen] = useState(false);

        const handleConfirm = () => {
            onConfirm();
            setOpen(false);
        };

        return (
            <AlertDialog open={open} onOpenChange={setOpen}>
                <TooltipProvider>
                    <Tooltip>
                        <TooltipTrigger asChild>
                            <AlertDialogTrigger asChild>
                                <Button
                                    variant="ghost"
                                    size={size}
                                    disabled={disabled || loading}
                                    className={cn(
                                        "h-9 w-9 p-0 rounded-full bg-red-50 text-red-500 hover:bg-red-100 hover:text-red-600",
                                        className
                                    )}
                                >
                                    {loading ? (
                                        <div className="h-4 w-4 animate-spin rounded-full border-2 border-t-transparent" />
                                    ) : (
                                        <Trash2 className="h-4 w-4" />
                                    )}
                                    <span className="sr-only">Delete</span>
                                </Button>
                            </AlertDialogTrigger>
                        </TooltipTrigger>
                        <TooltipContent>
                            <p>{tooltip}</p>
                        </TooltipContent>
                    </Tooltip>
                </TooltipProvider>
                <AlertDialogContent>
                    <AlertDialogHeader>
                        <AlertDialogTitle>Are you sure?</AlertDialogTitle>
                        <AlertDialogDescription>
                            This action cannot be undone. This will permanently delete the item.
                        </AlertDialogDescription>
                    </AlertDialogHeader>
                    <AlertDialogFooter>
                        <AlertDialogCancel>Cancel</AlertDialogCancel>
                        <AlertDialogAction onClick={handleConfirm}>
                            Yes, delete
                        </AlertDialogAction>
                    </AlertDialogFooter>
                </AlertDialogContent>
            </AlertDialog>
        );
    };


