import { createApiRequestEpic, createApiRequestWithFiles, updateByIdApiRequestEpic, deleteApiRequestEpic, getAllWithPayloadApiRequestEpic, updateByIdApiRequestWithFiles } from "./epicsTemplate";

export const fetchGalleryEpics = getAllWithPayloadApiRequestEpic("FETCH_GALLERY", "/gallery/all");
export const updateGalleryEpics = updateByIdApiRequestWithFiles("UPDATE_GALLERY", "/gallery/update");
export const createGalleryEpics = createApiRequestWithFiles("CREATE_GALLERY", "/gallery/create");
export const deleteGalleryEpics = deleteApiRequestEpic("DELETE_GALLERY", "/gallery");
