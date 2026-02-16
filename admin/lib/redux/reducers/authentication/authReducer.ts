import { openNotificationWithIcon } from '@/lib/helpers/notification';
import {
    getLocalStorage,
    removeLocalStorage,
    setLocalStorage,
} from "../../../helpers/frontendHelpers";


interface State {
    isLoading: boolean;
    loginSuccess: boolean;
    user: any;
    token?: string;
    error?: boolean;
    message?: string;
    isLoggedIn?: boolean;
}
interface Action {
    type: string;
    payload?: any;
}

const initialState: State = {
    isLoading: false,
    loginSuccess: false,
    user: null,
    token: typeof window !== 'undefined' ? getLocalStorage('token') || null : null,
    isLoggedIn: typeof window !== 'undefined' ? !!getLocalStorage('token') : false,
};

export default function (state: State = initialState, action: Action): State {
    const { type, payload } = action;

    switch (type) {
        case 'ADMIN_LOGIN_REQUEST':
            return {
                ...state,
                isLoading: true,
                error: false,
                message: '',
            };
        case 'ADMIN_LOGIN_SUCCESS':
            openNotificationWithIcon("success", "Login successful");
            setLocalStorage('token', payload.token);
            console.log("User ID:", payload.user?.id);
            setLocalStorage('userId', payload.user?.id);
            return {
                ...state,
                user: payload,
                isLoggedIn: true,
                token: payload.token,
                isLoading: false,
                error: false,
                message: 'Login successful',
            };
        case 'ADMIN_LOGIN_FAILURE':
            openNotificationWithIcon("error", payload?.message || 'Login failed');
            return {
                ...state,
                isLoading: false,
                error: true,
                message: payload?.message || 'Login failed',
            };
        case 'ADMIN_LOGOUT':
            removeLocalStorage('token');
            return {
                ...state,
                user: null,
                isLoggedIn: false,
                token: "",
                isLoading: false,
                error: false,
                message: '',
            };
        case 'HYDRATE_AUTH':
            const token = getLocalStorage('token');
            return {
                ...state,
                token: token || null,
                isLoggedIn: !!token,
            };
        default:
            return {
                ...state,
                isLoading: false,
                error: false,
                message: '',
            }
    }
}