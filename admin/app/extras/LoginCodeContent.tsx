import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Card, CardHeader, CardTitle, CardContent } from '../../components/ui/card';
import { Button } from '../../components/ui/button';
import { KeyRound, Edit } from 'lucide-react';
import ModalDialogWrapper from '../../components/ModalDialogWrapper';
import LoginCodeForm from './LoginCodeForm';
import { RootState } from '@/lib/redux/store';

export default function LoginCodeContent() {
    const dispatch = useDispatch();
    const { loginCode, loginCodeLoading, bannerSuccess } = useSelector((state: RootState) => state.commonReducer);
    const [showModal, setShowModal] = useState(false);

    useEffect(() => {
        dispatch({ type: 'GET_LOGIN_CODE_REQUEST' });
    }, [dispatch]);

    useEffect(() => {
        if (bannerSuccess) {
            setShowModal(false);
            dispatch({ type: 'GET_LOGIN_CODE_REQUEST' });
        }
    }, [bannerSuccess, dispatch]);



    return (
        <Card className="border-nepal-blue/20">
            <CardHeader className="bg-nepal-blue/5">
                <CardTitle className="flex items-center gap-2 text-nepal-blue">
                    <KeyRound className="h-5 w-5" />  Authorization Code
                </CardTitle>
            </CardHeader>
            <CardContent className="pt-6">
                {/* Enhanced styling with nepal-blue colors and better layout */}
                <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg border border-nepal-blue/10">
                    <div className="flex flex-col gap-1">
                        <span className="text-sm text-gray-600">Current Authorization Code</span>
                        <span className="font-mono text-lg font-semibold text-nepal-blue">
                            {loginCode?.code || 'Loading...'}
                        </span>
                    </div>
                    <Button
                        variant="outline"
                        onClick={() => setShowModal(true)}
                        disabled={loginCodeLoading}
                        className="border-nepal-blue text-nepal-blue hover:bg-nepal-blue hover:text-white"
                    >
                        <Edit className="mr-2 h-4 w-4" /> Update Code
                    </Button>
                </div>

                {loginCodeLoading && (
                    <div className="flex items-center justify-center py-4 mt-4">
                        <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-nepal-blue"></div>
                        <span className="ml-2 text-sm text-gray-600">Loading...</span>
                    </div>
                )}
            </CardContent>
            <ModalDialogWrapper
                open={showModal}
                setOpen={setShowModal}
                title="Update Authorization Code"
                subTitle="Change the authorization code for user access"
                className="w-[50vw] max-w-none overflow-hidden z-[101] flex flex-col p-4"
            >
                <LoginCodeForm
                    onClose={() => setShowModal(false)}
                    currentLoginCode={loginCode?.code || ''}
                    loading={loginCodeLoading}
                />
            </ModalDialogWrapper>
        </Card>
    );
}
