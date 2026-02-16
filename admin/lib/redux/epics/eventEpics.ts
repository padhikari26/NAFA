
import { createApiRequestEpic, createApiRequestWithFiles, updateByIdApiRequestEpic, deleteApiRequestEpic, getAllApiRequestEpic, getAllWithPayloadApiRequestEpic, getByIdApiRequestEpic, updateByIdApiRequestWithFiles } from "./epicsTemplate";



export const fetchEventsEpics = getAllWithPayloadApiRequestEpic("FETCH_EVENTS", "/events/all");
export const updateEventEpics = updateByIdApiRequestWithFiles("UPDATE_EVENT", "/events/update");
export const createEventEpics = createApiRequestWithFiles("CREATE_EVENT", "/events/create");
export const deleteEventEpics = deleteApiRequestEpic("DELETE_EVENT", "/events");
export const createReminderEpics = createApiRequestEpic("CREATE_REMINDER", "/events/reminder");

