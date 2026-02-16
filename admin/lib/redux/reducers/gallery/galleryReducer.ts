import { openNotificationWithIcon } from '@/lib/helpers/notification';

interface Gallery {
    _id?: string;
    id?: string;
    title: string;
    medias: any[];
}

interface State {
    isLoading: boolean;
    error?: boolean;
    message?: string;
    galleries: Gallery[];
    total?: number;
    page: number;
    totalPages?: number;
    selectedGallery?: Gallery;
    createUpdateSuccess?: boolean;
    deleteSuccess?: boolean;
}

interface Action {
    type: string;
    payload?: any;
}

const initialState: State = {
    isLoading: false,
    error: false,
    message: '',
    galleries: [],
    page: 1,
    createUpdateSuccess: false,
};

export default function (state: State = initialState, action: Action): State {
    const { type, payload } = action;
    switch (type) {
        case "SET_GALLERY_PAGE":
            return {
                ...state,
                page: payload.page
            }
        case 'SET_SELECTED_GALLERY':
            return {
                ...state,
                selectedGallery: payload,
            };
        case 'FETCH_GALLERY_REQUEST':
            return {
                ...state,
                isLoading: true,
                error: false,
                message: '',
            };
        case 'FETCH_GALLERY_SUCCESS':
            return {
                ...state,
                galleries: payload.data,
                page: payload.page,
                totalPages: payload.totalPages,
                total: payload.total,
                isLoading: false,
                error: false,
                message: 'Gallery fetched successfully',
            };
        case 'FETCH_GALLERY_FAILURE':
            openNotificationWithIcon("error", payload?.message || 'Failed to fetch gallery');
            return {
                ...state,
                isLoading: false,
                error: true,
                message: payload?.message || 'Failed to fetch gallery',
            };
        case 'CREATE_GALLERY_REQUEST':
        case 'UPDATE_GALLERY_REQUEST':
            return {
                ...state,
                isLoading: true,
                error: false,
                message: '',
                createUpdateSuccess: false,
            };
        case 'CREATE_GALLERY_SUCCESS':
            openNotificationWithIcon("success", 'Gallery created successfully');
            return {
                ...state,
                isLoading: false,
                error: false,
                createUpdateSuccess: true,
                message: 'Gallery created successfully',
            };
        case 'UPDATE_GALLERY_SUCCESS':
            openNotificationWithIcon("success", 'Gallery updated successfully');
            return {
                ...state,
                isLoading: false,
                error: false,
                createUpdateSuccess: true,
                message: 'Gallery updated successfully',
            };
        case 'CREATE_GALLERY_FAILURE':
        case 'UPDATE_GALLERY_FAILURE':
            openNotificationWithIcon("error", payload?.message || 'Operation failed');
            return {
                ...state,
                isLoading: false,
                error: true,
                createUpdateSuccess: false,
                message: payload?.message || 'Operation failed',
            };
        case 'DELETE_GALLERY_REQUEST':
            return {
                ...state,
                isLoading: true,
                error: false,
                message: '',
                deleteSuccess: false,
            };
        case 'DELETE_GALLERY_SUCCESS':
            openNotificationWithIcon("success", 'Gallery deleted successfully');
            return {
                ...state,
                isLoading: false,
                error: false,
                deleteSuccess: true,
                message: 'Gallery deleted successfully',
                galleries: state.galleries.filter(gallery => gallery._id !== payload.id),
            };
        case 'DELETE_GALLERY_FAILURE':
            openNotificationWithIcon("error", payload?.message || 'Failed to delete gallery');
            return {
                ...state,
                isLoading: false,
                error: false,
                message: payload?.message || 'Failed to delete gallery',
                deleteSuccess: false,
            };
        default:
            return state;
    }
}
