import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Card, CardContent } from '../../components/ui/card';
import { Button } from '../../components/ui/button';
import { Lock, Shield } from 'lucide-react';
import ChangePasswordForm from './ChangePasswordForm';

export default function ChangePasswordContent() {
    const [showForm, setShowForm] = useState(false);
    const dispatch = useDispatch();
    const { changePasswordLoading, changePasswordSuccess } = useSelector((state: any) => state.commonReducer);

    const handleOpenForm = () => {
        setShowForm(true);
    };

    const handleCloseForm = () => {
        setShowForm(false);
    };

    useEffect(() => {
        if (changePasswordSuccess) {
            setShowForm(false);
            dispatch({ type: "ADMIN_LOGOUT" });
        }
    }, [changePasswordSuccess]);

    if (showForm) {
        return (
            <ChangePasswordForm
                onClose={handleCloseForm}
                loading={changePasswordLoading}
            />
        );
    }

    return (
        <div className="space-y-6">
            <Card>
                <CardContent className="pt-6">
                    <div className="text-center space-y-4">
                        <div className="flex justify-center">
                            <div className="p-4 bg-nepal-blue/10 rounded-full">
                                <Shield className="h-8 w-8 text-nepal-blue" />
                            </div>
                        </div>

                        <div>
                            <h3 className="text-xl font-semibold text-gray-900 mb-2">
                                Admin Password Security
                            </h3>
                            <p className="text-gray-600 mb-6">
                                Keep your admin account secure by regularly updating your password.
                                Choose a strong password that includes a mix of letters, numbers, and special characters.
                            </p>
                        </div>

                        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 text-left">
                            <h4 className="font-medium text-blue-900 mb-2">Password Security Tips:</h4>
                            <ul className="text-sm text-blue-800 space-y-1 list-disc list-inside">
                                <li>Use at least 8 characters</li>
                                <li>Include uppercase and lowercase letters</li>
                                <li>Add numbers and special characters</li>
                                <li>Avoid common words or personal information</li>
                                <li>Don't reuse passwords from other accounts</li>
                            </ul>
                        </div>

                        <Button
                            onClick={handleOpenForm}
                            className="bg-nepal-blue hover:bg-nepal-blue/90"
                            disabled={changePasswordLoading}
                        >
                            <Lock className="h-4 w-4 mr-2" />
                            Change Password
                        </Button>
                    </div>
                </CardContent>
            </Card>
        </div>
    );
}