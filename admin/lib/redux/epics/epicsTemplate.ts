/** @format */

import axios from "axios";
import { Epic, ofType } from "redux-observable";
import { from, of } from "rxjs";
import { catchError, mergeMap } from "rxjs/operators";
import { API } from "../../helpers/baseUrls";
import { getLocalStorage } from "../../helpers/frontendHelpers";

// const localhostBaseUrl = "https://96aa0e53234c.ngrok-free.app";
interface Action<T = any> {
    type: string;
    payload?: T;
}

interface ApiResponse<T = any> {
    data: T;
}

export function getAllApiRequestEpic<T>(
    actionType: string,
    apiEndpoint: string
): Epic {
    return (action$) =>
        action$.pipe(
            ofType(`${actionType}_REQUEST`),
            mergeMap(() => {
                return from(API.get<ApiResponse<T>>(apiEndpoint)).pipe(
                    mergeMap((response) =>
                        of<Action>({
                            type: `${actionType}_SUCCESS`,
                            payload: response.data,
                        })
                    ),
                    catchError((error) =>
                        of<Action>({
                            type: `${actionType}_FAILURE`,
                            payload: error?.response?.data
                        })
                    )
                );
            })
        );
}

export function getAllWithPayloadApiRequestEpic<T>(
    actionType: string,
    apiEndpoint: string
): Epic {
    return (action$) =>
        action$.pipe(
            ofType(`${actionType}_REQUEST`),
            mergeMap((action: Action<T>) => {
                return from(API.post<ApiResponse<T>>(apiEndpoint, action.payload)).pipe(
                    mergeMap((response) =>
                        of<Action>({
                            type: `${actionType}_SUCCESS`,
                            payload: response.data,
                        })
                    ),
                    catchError((error) =>
                        of<Action>({
                            type: `${actionType}_FAILURE`,
                            payload: error?.response?.data
                        })
                    )
                );
            })
        );
}

export function createApiRequestEpic<T>(
    actionType: string,
    apiEndpoint: string
): Epic {
    return (action$) =>
        action$.pipe(
            ofType(`${actionType}_REQUEST`),
            mergeMap((action: Action<T>) => {
                return from(API.post<ApiResponse<T>>(apiEndpoint, action.payload)).pipe(
                    mergeMap((response) =>
                        of<Action>({
                            type: `${actionType}_SUCCESS`,
                            payload: response.data,
                        })
                    ),
                    catchError((error) =>
                        of<Action>({
                            type: `${actionType}_FAILURE`,
                            payload: error?.response?.data
                        })
                    )
                );
            })
        );
}

export function createUpdateWithArrayPayloadApiRequestEpic<T>(
    actionType: string,
    apiEndpoint: string
): Epic {
    return (action$) =>
        action$.pipe(
            ofType(`${actionType}_REQUEST`),
            mergeMap((action: Action<T>) =>
                from(
                    API.post<ApiResponse<T>>(apiEndpoint, [{ ...action.payload }])
                ).pipe(
                    mergeMap((response) =>
                        of<Action>({
                            type: `${actionType}_SUCCESS`,
                            payload: response.data,
                        })
                    ),
                    catchError((error) =>
                        of<Action>({
                            type: `${actionType}_FAILURE`,
                            payload: error?.response?.data
                        })
                    )
                )
            )
        );
}
export function updateByIdApiRequestEpic<T extends { _id: string | number }>(
    actionType: string,
    apiEndpoint: string
): Epic {
    return (action$) =>
        action$.pipe(
            ofType(`${actionType}_REQUEST`),
            mergeMap((action: Action<T>) => {
                const { _id, ...payloadWithoutId } = action.payload || {};
                return from(
                    API.put<ApiResponse<T>>(`${apiEndpoint}/${_id}`, payloadWithoutId)
                ).pipe(
                    mergeMap((response) =>
                        of<Action>({
                            type: `${actionType}_SUCCESS`,
                            payload: response.data,
                        })
                    ),
                    catchError((error) =>
                        of<Action>({
                            type: `${actionType}_FAILURE`,
                            payload: error?.response?.data
                        })
                    )
                );
            })
        );
}

export function createApiRequestWithFiles<T>(
    actionType: string,
    apiEndpoint: string,
): Epic {
    return (action$) =>
        action$.pipe(
            ofType(`${actionType}_REQUEST`),
            mergeMap((action: Action<T>) => {
                const formData = new FormData();
                const payload = action.payload as any;
                if (payload.files) {
                    if (Array.isArray(payload.files)) {
                        payload.files.forEach((file: File) => {
                            formData.append('files', file, file.name);
                        });
                    } else {
                        formData.append('files', payload.files, payload.files.name);
                    }
                }
                Object.keys(payload).forEach(key => {
                    if (key !== 'files') {
                        const value = payload[key];
                        if (Array.isArray(value)) {
                            value.forEach((item, index) => {
                                formData.append(`${key}[${index}]`, item);
                            });
                        } else if (value !== undefined && value !== null) {
                            formData.append(key, value.toString());
                        }
                    }
                });

                const apiCall = API.post<ApiResponse<T>>(apiEndpoint, formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                    },
                });

                return from(apiCall).pipe(
                    mergeMap((response) =>
                        of<Action>({
                            type: `${actionType}_SUCCESS`,
                            payload: response.data,
                        })
                    ),
                    catchError((error) =>
                        of<Action>({
                            type: `${actionType}_FAILURE`,
                            payload: error?.response?.data
                        })
                    )
                );
            })
        );
}

export function updateByIdApiRequestWithFiles<T extends { _id: string | number }>(
    actionType: string,
    apiEndpoint: string
): Epic {
    return (action$) =>
        action$.pipe(
            ofType(`${actionType}_REQUEST`),
            mergeMap((action: Action<T>) => {
                const formData = new FormData();
                const payload = action.payload as any;
                const { _id, ...payloadWithoutId } = payload;

                // Handle files if they exist
                if (payloadWithoutId.files) {
                    if (Array.isArray(payloadWithoutId.files)) {
                        payloadWithoutId.files.forEach((file: File) => {
                            formData.append('files', file, file.name);
                        });
                    } else {
                        formData.append('files', payloadWithoutId.files, payloadWithoutId.files.name);
                    }
                }

                // Handle other form fields
                Object.keys(payloadWithoutId).forEach(key => {
                    if (key !== 'files') {
                        const value = payloadWithoutId[key];
                        if (Array.isArray(value)) {
                            // Handle array fields like deleteIds
                            value.forEach((item, index) => {
                                formData.append(`${key}[${index}]`, item);
                            });
                        } else if (value !== undefined && value !== null) {
                            formData.append(key, value.toString());
                        }
                    }
                });

                return from(
                    API.put<ApiResponse<T>>(`${apiEndpoint}/${_id}`, formData, {
                        headers: {
                            'Content-Type': 'multipart/form-data',
                        },
                    })
                ).pipe(
                    mergeMap((response) =>
                        of<Action>({
                            type: `${actionType}_SUCCESS`,
                            payload: response.data,
                        })
                    ),
                    catchError((error) =>
                        of<Action>({
                            type: `${actionType}_FAILURE`,
                            payload: error?.response?.data
                        })
                    )
                );
            })
        );
}

export function getByIdApiRequestEpic<T>(
    actionType: string,
    apiEndpoint: string
): Epic {
    return (action$) =>
        action$.pipe(
            ofType(`${actionType}_REQUEST`),
            mergeMap((action: Action<T>) => {
                return from(
                    API.get<ApiResponse<T>>(`${apiEndpoint}/${action.payload}`)
                ).pipe(
                    mergeMap((response) =>
                        of<Action>({
                            type: `${actionType}_SUCCESS`,
                            payload: response.data,
                        })
                    ),
                    catchError((error) =>
                        of<Action>({
                            type: `${actionType}_FAILURE`,
                            payload: error?.response?.data
                        })
                    )
                );
            })
        );
}

export function deleteApiRequestEpic<T>(
    actionType: string,
    apiEndpoint: string
): Epic {
    return (action$) =>
        action$.pipe(
            ofType(`${actionType}_REQUEST`),
            mergeMap((action: Action<T>) => {

                return from(API.delete<ApiResponse<T>>(`${apiEndpoint}/${action.payload}`)).pipe(
                    mergeMap((response) =>
                        of<Action>({
                            type: `${actionType}_SUCCESS`,
                            payload: response.data,
                        })
                    ),
                    catchError((error) =>
                        of<Action>({
                            type: `${actionType}_FAILURE`,
                            payload: error?.response?.data,
                        })
                    )
                );
            })
        );
}
