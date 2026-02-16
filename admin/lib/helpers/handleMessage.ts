/** @format */

import { toast } from "sonner";

export function useHandleMessage() {
    const openLoadingMessage = (content: string, key?: string) => {
        return toast.loading(content);
    };

    const closeLoadingWithSuccess = (content: string, toastId?: string | number) => {
        if (toastId) {
            toast.success(content, { id: toastId });
        } else {
            toast.dismiss();
            toast.success(content);
        }
    };

    const closeLoadingWithError = (content: string, toastId?: string | number) => {
        if (toastId) {
            toast.error(content, { id: toastId });
        } else {
            toast.dismiss();
            toast.error(content);
        }
    };

    return { openLoadingMessage, closeLoadingWithSuccess, closeLoadingWithError };
}
