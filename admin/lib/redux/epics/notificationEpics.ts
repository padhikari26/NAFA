
import { createApiRequestEpic, createApiRequestWithFiles, updateByIdApiRequestEpic, deleteApiRequestEpic, getAllApiRequestEpic, getAllWithPayloadApiRequestEpic, getByIdApiRequestEpic, updateByIdApiRequestWithFiles } from "./epicsTemplate";



export const fetchNotificationEpics = getAllWithPayloadApiRequestEpic("FETCH_NOTIFICATIONS", "/notification/all");
export const createNotificationEpics = createApiRequestEpic("CREATE_NOTIFICATIONS", "/notification/create");
export const deleteNotificationEpics = deleteApiRequestEpic("DELETE_NOTIFICATIONS", "/notification");

