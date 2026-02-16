import { createApiRequestEpic, deleteApiRequestEpic, getAllApiRequestEpic, getAllWithPayloadApiRequestEpic, getByIdApiRequestEpic } from "./epicsTemplate";


export const adminLoginEpics = createApiRequestEpic("ADMIN_LOGIN", "/auth/admin/login");





