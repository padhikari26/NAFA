import { getAllApiRequestEpic, createApiRequestWithFiles, updateByIdApiRequestEpic, updateByIdApiRequestWithFiles } from "../epics/epicsTemplate";

export const fetchTeamsEpics = getAllApiRequestEpic("FETCH_TEAMS", "/teams");
export const createTeamEpics = createApiRequestWithFiles("CREATE_TEAM", "/teams");
export const updateTeamEpics = updateByIdApiRequestWithFiles("UPDATE_TEAM", "/teams");

