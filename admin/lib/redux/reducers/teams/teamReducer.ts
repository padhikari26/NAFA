import { openNotificationWithIcon } from '@/lib/helpers/notification';
import { TeamType } from '../../../types';


export interface Team {
    _id?: string;
    type: TeamType;
    content: string;
    media: any[];
}

interface State {
    teams: Team[];
    loading: boolean;
    error: any;
    createUpdateSuccess: boolean;
}

const initialState: State = {
    teams: [],
    loading: false,
    error: null,
    createUpdateSuccess: false,
};

interface Action {
    type: string;
    payload?: any;
}

export default function (state: State = initialState, action: Action): State {
    const { type, payload } = action;

    switch (type) {
        case 'FETCH_TEAMS_REQUEST':
            return { ...state, loading: true, error: null };
        case 'FETCH_TEAMS_SUCCESS':
            return { ...state, loading: false, teams: payload.data };
        case 'FETCH_TEAMS_FAILURE':
            openNotificationWithIcon("error", "Failed to fetch teams");
            return { ...state, loading: false, error: payload };
        case 'CREATE_TEAM_REQUEST':
        case 'UPDATE_TEAM_REQUEST':
            return { ...state, createUpdateSuccess: false, loading: true, error: null };
        case 'CREATE_TEAM_SUCCESS':
        case 'UPDATE_TEAM_SUCCESS':
            openNotificationWithIcon("success", "Team created/updated successfully");
            return { ...state, loading: false, createUpdateSuccess: true };
        case 'CREATE_TEAM_FAILURE':
        case 'UPDATE_TEAM_FAILURE':
            openNotificationWithIcon("error", "Failed to create/update team");
            return { ...state, createUpdateSuccess: false, loading: false, error: payload };
        default:
            return state;
    }
}
