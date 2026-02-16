import React, { useState, useRef, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import type { AppDispatch, RootState } from '../../lib/redux/store';
import { Card, CardHeader, CardTitle, CardContent } from '../../components/ui/card';
import { Button } from '../../components/ui/button';
import { Image } from 'lucide-react';
import imageUrl from '@/lib/helpers/baseUrls';
import dayjs from 'dayjs';

type BannerFormProps = {
    onClose: () => void;
    isEdit?: boolean;
    bannerData?: any;
};

const BannerForm: React.FC<BannerFormProps> = ({ onClose, isEdit = false, bannerData }) => {
    const dispatch = useDispatch<AppDispatch>();
    const { bannerLoading, bannerSuccess } = useSelector((state: RootState) => state.commonReducer);
    const [formData, setFormData] = useState({
        startDate: bannerData?.startDate || '',
        endDate: bannerData?.endDate || '',
        media: null as File | null,
        mediaPreview: bannerData?.media?.path || '',
    });
    const fileInputRef = useRef<HTMLInputElement>(null);


    const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleMediaUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files && e.target.files.length > 0) {
            const file = e.target.files[0];
            setFormData({
                ...formData,
                media: file,
                mediaPreview: URL.createObjectURL(file),
            });
        }
    };

    const removeMedia = () => {
        setFormData({ ...formData, media: null, mediaPreview: '' });
    };

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        const payload: any = {
            startDate: formData.startDate,
            endDate: formData.endDate,
        };
        if (formData.media) {
            payload.files = [formData.media];
        }
        if (isEdit && bannerData?._id) {
            payload._id = bannerData._id;
            dispatch({ type: 'UPDATE_BANNER_REQUEST', payload });
        } else {
            dispatch({ type: 'CREATE_BANNER_REQUEST', payload });
        }
    };

    return (
        <form onSubmit={handleSubmit} className="space-y-6">
            <Card>
                <CardContent className="space-y-4 mt-4 pt-4">
                    <div className="flex gap-2">
                        <div className="w-1/2">
                            <label className="block mb-2 font-medium">Start Date</label>
                            <input
                                type="date"
                                name="startDate"
                                value={formData.startDate && dayjs(formData.startDate).isValid() ? dayjs(formData.startDate).format('YYYY-MM-DD') : ''}
                                onChange={handleInputChange}
                                className="border p-2 rounded w-full"
                                required
                                disabled={bannerLoading}
                            />
                        </div>
                        <div className="w-1/2">
                            <label className="block mb-2 font-medium">End Date</label>
                            <input
                                type="date"
                                name="endDate"
                                value={formData.endDate && dayjs(formData.endDate).isValid() ? dayjs(formData.endDate).format('YYYY-MM-DD') : ''}
                                onChange={handleInputChange}
                                className="border p-2 rounded w-full"
                                required
                                disabled={bannerLoading}
                            />
                        </div>
                    </div>
                    <div>
                        <label className="block mb-2 font-medium">Banner Media</label>
                        <label className="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
                            <div className="flex flex-col items-center justify-center pt-5 pb-6">
                                <Image className="w-8 h-8 mb-4 text-gray-500" />
                                <p className="mb-2 text-sm text-gray-500">
                                    <span className="font-semibold">Click to upload</span> or drag and drop
                                </p>
                                <p className="text-xs text-gray-500">Images only</p>
                            </div>
                            <input
                                ref={fileInputRef}
                                type="file"
                                accept="image/*"
                                onChange={handleMediaUpload}
                                className="hidden"
                                disabled={bannerLoading}
                            />
                        </label>
                        {formData.mediaPreview && (
                            <div className="mt-2 flex items-center gap-2">
                                <img
                                    src={formData.media ? formData.mediaPreview : imageUrl + formData.mediaPreview}
                                    alt="banner"
                                    className="h-20 w-20 object-contain rounded"
                                />
                                <Button type="button" variant="ghost" size="sm" onClick={removeMedia} disabled={bannerLoading}>
                                    Remove
                                </Button>
                            </div>
                        )}
                    </div>
                    {bannerLoading && (
                        <div className="flex items-center justify-center py-4">
                            <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-nepal-blue"></div>
                            <span className="ml-2 text-sm text-gray-600">Uploading...</span>
                        </div>
                    )}
                </CardContent>
            </Card>
            <div className="flex justify-end gap-2">
                <Button type="button" variant="outline" onClick={onClose} disabled={bannerLoading}>Cancel</Button>
                <Button type="submit" className="bg-nepal-blue hover:bg-nepal-blue/90" disabled={bannerLoading}>
                    {isEdit ? 'Update Banner' : 'Create Banner'}
                </Button>
            </div>
        </form>
    );
};

export { BannerForm };
