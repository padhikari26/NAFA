import { createApiRequestEpic, createApiRequestWithFiles, updateByIdApiRequestEpic, deleteApiRequestEpic, getAllApiRequestEpic, getAllWithPayloadApiRequestEpic, getByIdApiRequestEpic, updateByIdApiRequestWithFiles } from "./epicsTemplate";


export const createLoginCodeEpics = createApiRequestEpic("CREATE_LOGIN_CODE", "/auth/logincode");
export const getLoginCodeEpics = getAllApiRequestEpic("GET_LOGIN_CODE", "/auth/logincode");
export const createBannerEpics = createApiRequestWithFiles("CREATE_BANNER", "/events/banner/create");
export const updateBannerEpics = updateByIdApiRequestWithFiles("UPDATE_BANNER", "/events/banner");
export const deleteBannerEpics = deleteApiRequestEpic("DELETE_BANNER", "/events/banner");
export const getBannerEpics = getAllApiRequestEpic("GET_BANNER", "/events/banner/popup");
export const changeAdminPasswordEpics = updateByIdApiRequestEpic("CHANGE_ADMIN_PASSWORD", "auth/admin/change-password");
