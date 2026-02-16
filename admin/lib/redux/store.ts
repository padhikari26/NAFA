import { configureStore } from "@reduxjs/toolkit";
import { createEpicMiddleware } from "redux-observable";

import { rootEpic } from "./rootEpics";


import authReducer from "./reducers/authentication";
import eventReducer from "./reducers/events";
import memberReducer from "./reducers/member";
import galleryReducer from "./reducers/gallery";
import notificationReducer from "./reducers/notification";
import teamsReducer from "./reducers/teams";
import commonReducer from "./reducers/common";

export const epicMiddleware = createEpicMiddleware();

export const store = configureStore({
    reducer: {
        ...authReducer,
        ...eventReducer,
        ...memberReducer,
        ...galleryReducer,
        ...notificationReducer,
        ...teamsReducer,
        ...commonReducer
    },
    middleware: (getDefaultMiddleware) =>
        getDefaultMiddleware({
            serializableCheck: {
                ignoredActions: [
                    "persist/PERSIST",
                    "CREATE_EVENT_REQUEST",
                    "UPDATE_EVENT_REQUEST",
                    "CREATE_GALLERY_REQUEST",
                    "UPDATE_GALLERY_REQUEST",
                    "CREATE_TEAM_REQUEST",
                    "UPDATE_TEAM_REQUEST",
                    "CREATE_BANNER_REQUEST",
                    "UPDATE_BANNER_REQUEST",
                ],
                ignoredActionsPaths: ["payload.files"],
            },
        }).concat(epicMiddleware),
});

epicMiddleware.run(rootEpic);

// Export types for use with TypeScript
export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

// Initialize SPI service
