
import { openNotificationWithIcon } from '@/lib/helpers/notification';
import { Member, Notifications } from '@/lib/types';


interface State {
    isLoading: boolean;
    error?: boolean;
    message?: string;
    notifications: Notifications[];
    total?: number;
    page: number;
    totalPages?: number;
    createSuccess?: boolean;
    deleteSuccess?: boolean;
    code?: string;
    codeLoading?: boolean;
}
interface Action {
    type: string;
    payload?: any;
}

const initialState: State = {
    isLoading: false,
    codeLoading: false,
    error: false,
    message: '',
    notifications: [],
    page: 1,
    createSuccess: false,
};

export default function (state: State = initialState, action: Action): State {
    const { type, payload } = action;

    switch (type) {
        case "SET_PAGE":
            return {
                ...state,
                page: payload.page
            }
        case "CREATE_NOTIFICATIONS_REQUEST":
            return { ...state, isLoading: true, error: false };
        case "CREATE_NOTIFICATIONS_SUCCESS":
            openNotificationWithIcon('success', 'Notification created successfully');
            return {
                ...state,
                isLoading: false,
                createSuccess: true,
                notifications: [...state.notifications],
                message: 'Notification created successfully',
            };
        case "CREATE_NOTIFICATIONS_FAILURE":
            openNotificationWithIcon('error', payload?.message);
            return { ...state, isLoading: false, error: true, message: payload?.message };
        case "FETCH_NOTIFICATIONS_REQUEST":
            return { ...state, isLoading: true, error: false };
        case "FETCH_NOTIFICATIONS_SUCCESS":
            return {
                ...state,
                isLoading: false,
                notifications: payload.data,
                total: payload.total,
                page: payload.page,
                totalPages: payload.totalPages,
                error: false,
            };
        case "FETCH_NOTIFICATIONS_FAILURE":
            openNotificationWithIcon('error', payload?.message);
            return { ...state, isLoading: false, error: true, message: payload?.message };
        case "DELETE_NOTIFICATIONS_REQUEST":
            return { ...state, isLoading: true, deleteSuccess: false };
        case "DELETE_NOTIFICATIONS_SUCCESS":
            return {
                ...state,
                isLoading: false,
                deleteSuccess: true,
                notifications: state.notifications.filter(m => m._id !== payload.id),
                message: 'Notification deleted successfully',
            };
        case "DELETE_NOTIFICATIONS_FAILURE":
            openNotificationWithIcon('error', payload?.message);
            return { ...state, isLoading: false, deleteSuccess: false, error: true, message: payload?.message };
        default:
            return state;
    }
}