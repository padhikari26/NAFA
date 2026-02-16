import { openNotificationWithIcon } from "@/lib/helpers/notification";

export interface Banner {
    _id?: string;
    startDate: any;
    endDate: any;
    media: any;
}

export interface LoginCode {
    _id?: string;
    code: string;
    createdAt: string;
    updatedAt: string;
}

interface State {
    error: any;
    loginCode: LoginCode | null;
    banner: Banner | null;
    bannerLoading: boolean;
    bannerSuccess: boolean;
    loginCodeLoading: boolean;
    changePasswordLoading: boolean;
    changePasswordSuccess: boolean;
}

const initialState: State = {
    error: null,
    banner: null,
    bannerSuccess: false,
    bannerLoading: false,
    loginCodeLoading: false,
    loginCode: null,
    changePasswordLoading: false,
    changePasswordSuccess: false
};

interface Action {
    type: string;
    payload?: any;
}

export default function (state: State = initialState, action: Action): State {
    const { type, payload } = action;

    switch (type) {
        case "CREATE_LOGIN_CODE_REQUEST":
            return { ...state, loginCodeLoading: true, error: null, bannerSuccess: false };
        case "CREATE_LOGIN_CODE_SUCCESS":
            return { ...state, loginCodeLoading: false, bannerSuccess: true };
        case "CREATE_LOGIN_CODE_FAILURE":
            return { ...state, loginCodeLoading: false, error: payload, bannerSuccess: false };
        case "GET_LOGIN_CODE_REQUEST":
            return { ...state, loginCodeLoading: true, error: null };
        case "GET_LOGIN_CODE_SUCCESS":
            return { ...state, loginCodeLoading: false, loginCode: payload };
        case "GET_LOGIN_CODE_FAILURE":
            openNotificationWithIcon("error", "Failed to fetch login code");
            return { ...state, loginCodeLoading: false, error: payload, loginCode: null };

        case "CREATE_BANNER_REQUEST":
            return { ...state, bannerLoading: true, error: null, bannerSuccess: false };
        case "CREATE_BANNER_SUCCESS":
            openNotificationWithIcon("success", "Banner created successfully");
            return { ...state, bannerLoading: false, bannerSuccess: true };
        case "CREATE_BANNER_FAILURE":
            openNotificationWithIcon("error", "Failed to create banner");
            return { ...state, bannerLoading: false, error: payload, bannerSuccess: false };

        case "UPDATE_BANNER_REQUEST":
            return { ...state, bannerLoading: true, error: null, bannerSuccess: false };
        case "UPDATE_BANNER_SUCCESS":
            openNotificationWithIcon("success", "Banner updated successfully");
            return { ...state, bannerLoading: false, bannerSuccess: true };
        case "UPDATE_BANNER_FAILURE":
            openNotificationWithIcon("error", "Failed to update banner");
            return { ...state, bannerLoading: false, error: payload, bannerSuccess: false };

        case "DELETE_BANNER_REQUEST":
            return { ...state, bannerLoading: true, error: null, bannerSuccess: false };
        case "DELETE_BANNER_SUCCESS":
            openNotificationWithIcon("success", "Banner deleted successfully");
            return { ...state, bannerLoading: false, bannerSuccess: true };
        case "DELETE_BANNER_FAILURE":
            openNotificationWithIcon("error", "Failed to delete banner");
            return { ...state, bannerLoading: false, error: payload, bannerSuccess: false };

        case "GET_BANNER_REQUEST":
            return { ...state, bannerLoading: true, error: null, bannerSuccess: false };
        case "GET_BANNER_SUCCESS":
            console.log("Banner fetched successfully:", payload.data);
            return { ...state, bannerLoading: false, banner: payload.data };
        case "GET_BANNER_FAILURE":
            openNotificationWithIcon("error", "Failed to fetch banner");
            return { ...state, bannerLoading: false, error: payload };

        case "CHANGE_ADMIN_PASSWORD_REQUEST":
            return { ...state, changePasswordLoading: true, error: null, changePasswordSuccess: false };
        case "CHANGE_ADMIN_PASSWORD_SUCCESS":
            openNotificationWithIcon("success", "Password changed successfully");
            return { ...state, changePasswordLoading: false, changePasswordSuccess: true };
        case "CHANGE_ADMIN_PASSWORD_FAILURE":
            openNotificationWithIcon("error", payload?.message || "Failed to change password");
            return { ...state, changePasswordLoading: false, error: payload, changePasswordSuccess: false };
        default:
            return state;
    }
}

