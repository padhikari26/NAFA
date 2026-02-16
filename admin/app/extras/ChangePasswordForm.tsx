import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Card, CardHeader, CardTitle, CardContent } from '../../components/ui/card';
import { Button } from '../../components/ui/button';
import { Lock, Eye, EyeOff } from 'lucide-react';
import { getLocalStorage } from '../../lib/helpers/frontendHelpers';
import { openNotificationWithIcon } from '@/lib/helpers/notification';
import { current } from '@reduxjs/toolkit';

export default function ChangePasswordForm({ onClose, loading }: { onClose: () => void; loading?: boolean }) {
    const [formData, setFormData] = useState({
        currentPassword: '',
        newPassword: '',
        confirmPassword: ''
    });
    const [showPasswords, setShowPasswords] = useState({
        current: false,
        new: false,
        confirm: false
    });
    const [errors, setErrors] = useState<{ [key: string]: string }>({});
    const dispatch = useDispatch();
    const { changePasswordSuccess } = useSelector((state: any) => state.commonReducer);

    // Reset form and close when password change is successful
    useEffect(() => {
        if (changePasswordSuccess) {
            setFormData({
                currentPassword: '',
                newPassword: '',
                confirmPassword: ''
            });
            onClose();
        }
    }, [changePasswordSuccess, onClose]);

    const handleInputChange = (field: string, value: string) => {
        setFormData(prev => ({ ...prev, [field]: value }));
        // Clear error when user starts typing
        if (errors[field]) {
            setErrors(prev => ({ ...prev, [field]: '' }));
        }
    };

    const togglePasswordVisibility = (field: 'current' | 'new' | 'confirm') => {
        setShowPasswords(prev => ({ ...prev, [field]: !prev[field] }));
    };

    const validateForm = () => {
        const newErrors: { [key: string]: string } = {};

        if (!formData.currentPassword) {
            newErrors.currentPassword = 'Current password is required';
        }

        if (!formData.newPassword) {
            newErrors.newPassword = 'New password is required';
        } else if (formData.newPassword.length < 6) {
            newErrors.newPassword = 'New password must be at least 6 characters';
        }

        if (!formData.confirmPassword) {
            newErrors.confirmPassword = 'Please confirm your password';
        } else if (formData.newPassword !== formData.confirmPassword) {
            newErrors.confirmPassword = 'Passwords do not match';
        }

        if (formData.currentPassword === formData.newPassword) {
            newErrors.newPassword = 'New password must be different from current password';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();

        if (!validateForm()) {
            return;
        }

        const adminId = getLocalStorage('userId');
        if (!adminId) {
            openNotificationWithIcon("error", "Admin ID not found");
            return;
        }

        dispatch({
            type: 'CHANGE_ADMIN_PASSWORD_REQUEST',
            payload: {
                _id: adminId,
                currentPassword: formData.currentPassword,
                newPassword: formData.newPassword

            }
        });
    };

    return (
        <form onSubmit={handleSubmit} className="space-y-4">
            <Card>
                <CardHeader>
                    <CardTitle className="flex items-center gap-2 text-nepal-blue">
                        <Lock className="h-5 w-5" />
                        Change Admin Password
                    </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                    {/* Current Password */}
                    <div>
                        <label className="block mb-2 font-medium text-gray-700">
                            Current Password
                        </label>
                        <div className="relative">
                            <input
                                type={showPasswords.current ? "text" : "password"}
                                value={formData.currentPassword}
                                onChange={(e) => handleInputChange('currentPassword', e.target.value)}
                                placeholder="Enter current password"
                                className={`border p-3 rounded w-full pr-10 ${errors.currentPassword ? 'border-red-500' : 'border-gray-300'
                                    }`}
                                required
                                disabled={loading}
                            />
                            <button
                                type="button"
                                onClick={() => togglePasswordVisibility('current')}
                                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700"
                                disabled={loading}
                            >
                                {showPasswords.current ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                            </button>
                        </div>
                        {errors.currentPassword && (
                            <p className="text-red-500 text-sm mt-1">{errors.currentPassword}</p>
                        )}
                    </div>

                    {/* New Password */}
                    <div>
                        <label className="block mb-2 font-medium text-gray-700">
                            New Password
                        </label>
                        <div className="relative">
                            <input
                                type={showPasswords.new ? "text" : "password"}
                                value={formData.newPassword}
                                onChange={(e) => handleInputChange('newPassword', e.target.value)}
                                placeholder="Enter new password"
                                className={`border p-3 rounded w-full pr-10 ${errors.newPassword ? 'border-red-500' : 'border-gray-300'
                                    }`}
                                required
                                disabled={loading}
                            />
                            <button
                                type="button"
                                onClick={() => togglePasswordVisibility('new')}
                                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700"
                                disabled={loading}
                            >
                                {showPasswords.new ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                            </button>
                        </div>
                        {errors.newPassword && (
                            <p className="text-red-500 text-sm mt-1">{errors.newPassword}</p>
                        )}
                    </div>

                    {/* Confirm Password */}
                    <div>
                        <label className="block mb-2 font-medium text-gray-700">
                            Confirm New Password
                        </label>
                        <div className="relative">
                            <input
                                type={showPasswords.confirm ? "text" : "password"}
                                value={formData.confirmPassword}
                                onChange={(e) => handleInputChange('confirmPassword', e.target.value)}
                                placeholder="Confirm new password"
                                className={`border p-3 rounded w-full pr-10 ${errors.confirmPassword ? 'border-red-500' : 'border-gray-300'
                                    }`}
                                required
                                disabled={loading}
                            />
                            <button
                                type="button"
                                onClick={() => togglePasswordVisibility('confirm')}
                                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700"
                                disabled={loading}
                            >
                                {showPasswords.confirm ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                            </button>
                        </div>
                        {errors.confirmPassword && (
                            <p className="text-red-500 text-sm mt-1">{errors.confirmPassword}</p>
                        )}
                    </div>
                </CardContent>
            </Card>

            <div className="flex justify-end gap-2">
                <Button
                    type="button"
                    variant="outline"
                    onClick={onClose}
                    disabled={loading}
                >
                    Cancel
                </Button>
                <Button
                    type="submit"
                    className="bg-nepal-blue hover:bg-nepal-blue/90"
                    disabled={loading}
                >
                    {loading ? 'Changing Password...' : 'Change Password'}
                </Button>
            </div>
        </form>
    );
}