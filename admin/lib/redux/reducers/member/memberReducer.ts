
import { openNotificationWithIcon } from '@/lib/helpers/notification';
import { Member } from '@/lib/types';


interface State {
    isLoading: boolean;
    error?: boolean;
    message?: string;
    members: Member[];
    total?: number;
    page: number;
    totalPages?: number;
    selectedMember?: Member;
    createUpdateSuccess?: boolean;
    deleteSuccess?: boolean;
    code?: string;
    codeLoading?: boolean;
    downloadLoading?: boolean;
}
interface Action {
    type: string;
    payload?: any;
}

const initialState: State = {
    isLoading: false,
    codeLoading: false,
    downloadLoading: false,
    error: false,
    message: '',
    members: [],
    page: 1,
    createUpdateSuccess: false,
};

export default function (state: State = initialState, action: Action): State {
    const { type, payload } = action;

    switch (type) {
        case "SET_PAGE":
            return {
                ...state,
                page: payload.page
            }
        case 'SET_SELECTED_MEMBER':
            return {
                ...state,
                selectedMember: payload,
            };
        case "FETCH_MEMBERS_REQUEST":
            return { ...state, isLoading: true, error: false };
        case "FETCH_MEMBERS_SUCCESS":
            return {
                ...state,
                isLoading: false,
                members: payload.data,
                total: payload.total,
                page: payload.page,
                totalPages: payload.totalPages,
                error: false,
            };
        case "FETCH_MEMBERS_FAILURE":
            openNotificationWithIcon('error', payload?.message);
            return { ...state, isLoading: false, error: true, message: payload?.message };
        case "UPDATE_MEMBER_REQUEST":
            return { ...state, isLoading: true, createUpdateSuccess: false };
        case "UPDATE_MEMBER_SUCCESS":
            openNotificationWithIcon('success', 'User updated successfully');
            return {
                ...state,
                isLoading: false,
                createUpdateSuccess: true,
                members: state.members.map(m => m._id === payload.id ? payload : m),
                message: 'User updated successfully',
            };
        case "UPDATE_MEMBER_FAILURE":
            openNotificationWithIcon('error', payload?.message);
            return { ...state, isLoading: false, error: true, message: payload?.message };
        case "DELETE_MEMBER_REQUEST":
            return { ...state, isLoading: true, deleteSuccess: false };
        case "DELETE_MEMBER_SUCCESS":
            return {
                ...state,
                isLoading: false,
                deleteSuccess: true,
                members: state.members.filter(m => m._id !== payload.id),
                message: 'User deleted successfully',
            };
        case "DELETE_MEMBER_FAILURE":
            openNotificationWithIcon('error', payload?.message);
            return { ...state, isLoading: false, error: true, message: payload?.message };
        case "DELETE_MEMBER_ACCOUNT_REQUEST":
            return { ...state, isLoading: true, deleteSuccess: false };
        case "DELETE_MEMBER_ACCOUNT_SUCCESS":
            openNotificationWithIcon('success', 'Member account deleted successfully');
            return {
                ...state,
                isLoading: false,
                deleteSuccess: true,
                members: state.members.filter(m => m._id !== payload.id),
                message: 'Member account deleted successfully',
            };
        case "DELETE_MEMBER_ACCOUNT_FAILURE":
            openNotificationWithIcon('error', payload?.message);
            return { ...state, isLoading: false, error: true, message: payload?.message };
        case "GENERATE_MEMBER_CODE_REQUEST":
            return { ...state, codeLoading: true };
        case "GENERATE_MEMBER_CODE_SUCCESS":
            return {
                ...state,
                codeLoading: false,
                code: payload.userCode,
            };
        case "GENERATE_MEMBER_CODE_FAILURE":
            openNotificationWithIcon('error', payload?.message);
            return { ...state, codeLoading: false, error: true, message: payload?.message };
        case "CLEAR_CODE":
            return { ...state, code: "", codeLoading: false };
        case "DOWNLOAD_MEMBERS_CSV_REQUEST":
            return { ...state, downloadLoading: true, error: false };
        case "DOWNLOAD_MEMBERS_CSV_SUCCESS":
            openNotificationWithIcon('success', 'CSV downloaded successfully');
            return { ...state, downloadLoading: false, error: false };
        case "DOWNLOAD_MEMBERS_CSV_FAILURE":
            openNotificationWithIcon('error', payload?.message || 'Failed to download CSV');
            return { ...state, downloadLoading: false, error: true, message: payload?.message };
        default:
            return state;
    }
}