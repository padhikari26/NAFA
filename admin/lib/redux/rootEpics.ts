import { Action } from "redux";
import { Epic, combineEpics } from "redux-observable";

import * as userEpics from "./epics/authEpics";
import * as eventEpics from "./epics/eventEpics";
import * as memberEpics from "./epics/memberEpics";
import * as galleryEpics from "./epics/galleryEpics";
import * as notificationEpics from "./epics/notificationEpics";
import * as teamsEpics from "./epics/teamsEpics";
import * as commonEpics from "./epics/commonEpics";

// Define the type for your epics
type AppEpic = Epic<Action<any>, Action<any>, void, any>;

// Define the type for your epic modules
type EpicModule = Record<string, AppEpic>;

const castEpicModule = (module: any): EpicModule => module as EpicModule;


// Combine all epics into a single root epic
export const rootEpic: any = combineEpics(
    ...Object.values(castEpicModule(userEpics)),
    ...Object.values(castEpicModule(eventEpics)),
    ...Object.values(castEpicModule(memberEpics)),
    ...Object.values(castEpicModule(galleryEpics)),
    ...Object.values(castEpicModule(notificationEpics)),
    ...Object.values(castEpicModule(teamsEpics)),
    ...Object.values(castEpicModule(commonEpics))
);
