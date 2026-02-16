import { toast } from "sonner";

type NotificationType = 'success' | 'info' | 'warning' | 'error';

export const openNotificationWithIcon = (type: NotificationType, message: string) => {
    const title = type === "error" ? "Error" : type === "info" ? "Info" : type === "warning" ? "Warning" : "Success";

    switch (type) {
        case 'success':
            toast.success(message, {
                description: title,
                duration: 3000
            });
            break;
        case 'info':
            toast.info(message, {
                description: title,
                duration: 3000
            });
            break;
        case 'warning':
            toast.warning(message, {
                description: title,
                duration: 3000
            });
            break;
        case 'error':
            toast.error(message, {
                description: title,
                duration: 3000
            });
            break;
        default:
            toast(message, {
                description: title,
                duration: 3000
            });
    }
};
