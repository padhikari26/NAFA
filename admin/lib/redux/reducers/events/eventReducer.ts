


// events, loading, currentPage, totalPages, filters


import { openNotificationWithIcon } from '@/lib/helpers/notification';
import { Event } from '@/lib/types';


interface State {
    isLoading: boolean;
    error?: boolean;
    message?: string;
    events: Event[];
    total?: number;
    page: number;
    totalPages?: number;
    selectedEvent?: Event;
    createUpdateSuccess?: boolean;
    deleteSuccess?: boolean;
    reminderLoading?: boolean;
    selectedReminder?: string;

}
interface Action {
    type: string;
    payload?: any;
}

const initialState: State = {
    isLoading: false,
    error: false,
    message: '',
    events: [],
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
            };
        case "SET_SELECTED_REMINDER":
            return {
                ...state,
                selectedReminder: payload
            };
        case 'SET_SELECTED_EVENT':
            return {
                ...state,
                selectedEvent: payload,
            };
        case 'FETCH_EVENTS_REQUEST':
            return {
                ...state,
                isLoading: true,
                error: false,
                message: '',
            };
        case 'FETCH_EVENTS_SUCCESS':
            return {
                ...state,
                events: payload.data,
                page: payload.page,
                totalPages: payload.totalPages,
                total: payload.total,
                isLoading: false,
                error: false,
                message: 'Events fetched successfully',
            };
        case 'FETCH_EVENTS_FAILURE':
            openNotificationWithIcon("error", payload?.message || 'Failed to fetch events');
            return {
                ...state,
                isLoading: false,
                error: true,
                message: payload?.message || 'Failed to fetch events',
            };
        case 'CREATE_EVENT_REQUEST':
        case 'UPDATE_EVENT_REQUEST':
            return {
                ...state,
                isLoading: true,
                error: false,
                message: '',
                createUpdateSuccess: false,
            };
        case 'CREATE_EVENT_SUCCESS':
            openNotificationWithIcon("success", 'Event created successfully');
            return {
                ...state,
                isLoading: false,
                error: false,
                createUpdateSuccess: true,
                message: 'Event created successfully',
            };
        case 'UPDATE_EVENT_SUCCESS':
            openNotificationWithIcon("success", 'Event updated successfully');
            return {
                ...state,
                isLoading: false,
                error: false,
                createUpdateSuccess: true,
                message: 'Event updated successfully',
            };
        case 'CREATE_EVENT_FAILURE':
        case 'UPDATE_EVENT_FAILURE':
            openNotificationWithIcon("error", payload?.message || 'Operation failed');
            return {
                ...state,
                isLoading: false,
                error: true,
                createUpdateSuccess: false,
                message: payload?.message || 'Operation failed',
            };
        case 'DELETE_EVENT_REQUEST':
            return {
                ...state,
                isLoading: true,
                error: false,
                message: '',
                deleteSuccess: false,
            };
        case 'DELETE_EVENT_SUCCESS':
            openNotificationWithIcon("success", 'Event deleted successfully');
            return {
                ...state,
                isLoading: false,
                error: false,
                deleteSuccess: true,
                message: 'Event deleted successfully',
                events: state.events.filter(event => event._id !== payload.id),
            };
        case 'DELETE_EVENT_FAILURE':
            openNotificationWithIcon("error", payload?.message || 'Failed to delete event');
            return {
                ...state,
                isLoading: false,
                error: false,
                message: payload?.message || 'Failed to delete event',
                deleteSuccess: false,
            };
        case "CREATE_REMINDER_REQUEST":
            return {
                ...state,
                error: false,
                message: '',
                reminderLoading: true,
            };
        case "CREATE_REMINDER_SUCCESS":
            openNotificationWithIcon("success", 'Reminder created successfully');
            return {
                ...state,
                error: false,
                reminderLoading: false,
                message: 'Reminder created successfully',
                selectedReminder: ""
            };
        case "CREATE_REMINDER_FAILURE":
            openNotificationWithIcon("error", payload?.message || 'Failed to create reminder');
            return {
                ...state,
                error: false,
                reminderLoading: false,
                message: payload?.message || 'Failed to create reminder',
                selectedReminder: ""
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