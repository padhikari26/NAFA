
import { createApiRequestEpic, createApiRequestWithFiles, updateByIdApiRequestEpic, deleteApiRequestEpic, getAllApiRequestEpic, getAllWithPayloadApiRequestEpic, getByIdApiRequestEpic, updateByIdApiRequestWithFiles } from "./epicsTemplate";
import { Epic, ofType } from "redux-observable";
import { from, of } from "rxjs";
import { catchError, mergeMap } from "rxjs/operators";
import { API } from "../../helpers/baseUrls";

interface Action<T = any> {
    type: string;
    payload?: T;
}

// Custom epic for CSV download
export const downloadMembersCsvEpic: Epic = (action$) =>
    action$.pipe(
        ofType('DOWNLOAD_MEMBERS_CSV_REQUEST'),
        mergeMap(() => {
            return from(
                API.get('/member/download-csv', {
                    responseType: 'text',
                })
            ).pipe(
                mergeMap((response) => {
                    const BOM = '\uFEFF';
                    let csvContent = response.data;
                    const blob = new Blob([csvContent], {
                        type: 'text/csv;charset=utf-8;'
                    });
                    const timestamp = new Date().toISOString().split('T')[0];
                    const filename = `members-${timestamp}.csv`;
                    const url = window.URL.createObjectURL(blob);
                    const link = document.createElement('a');
                    link.href = url;
                    link.download = filename;
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                    window.URL.revokeObjectURL(url);

                    return of<Action>({
                        type: 'DOWNLOAD_MEMBERS_CSV_SUCCESS',
                        payload: { message: 'CSV downloaded successfully' },
                    });
                }),
                catchError((error) =>
                    of<Action>({
                        type: 'DOWNLOAD_MEMBERS_CSV_FAILURE',
                        payload: error?.response?.data || { message: 'Failed to download CSV' }
                    })
                )
            );
        })
    );

export const fetchMembersEpics = getAllWithPayloadApiRequestEpic("FETCH_MEMBERS", "/member/all");
export const updateMemberEpics = updateByIdApiRequestEpic("UPDATE_MEMBER", "/member/profile");
export const deleteMemberEpics = deleteApiRequestEpic("DELETE_MEMBER_ACCOUNT", "/member/delete-account");
export const generateMemberCodeEpics = getAllApiRequestEpic("GENERATE_MEMBER_CODE", "/member/generate-code");
