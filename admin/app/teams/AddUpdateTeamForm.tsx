
import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { TeamType } from '../../lib/types';
import CKEditorWrapper from '../../components/CKEditorWrapper';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card';
import { Badge } from '../../components/ui/badge';
import { Upload, X, Image } from 'lucide-react';
import { Label } from '../../components/ui/label';
import { RootState } from '@/lib/redux/store';
import TinyMCEWrapper from '../../components/TinyMCEWrapper';
import { CommonFileUpload, ExistingFile, UploadedFile } from '@/components/form-items/common-file-upload';


interface AddUpdateTeamFormProps {
    onClose: () => void;
    isEdit?: boolean;
    teamData?: any;
    teamType: TeamType;
}

export default function AddUpdateTeamForm({ onClose, isEdit = false, teamData, teamType }: AddUpdateTeamFormProps) {
    const dispatch = useDispatch();
    const { loading } = useSelector((state: RootState) => state.teamsReducer)

    const [formData, setFormData] = useState({
        content: '',
    });
    const [uploadedImages, setUploadedImages] = useState<UploadedFile[]>([]);
    const [existingImages, setExistingImages] = useState<ExistingFile[]>([]);
    const [uploading, setUploading] = useState(false);
    const [deletedImages, setDeletedImages] = useState<string[]>([]);

    useEffect(() => {
        if (isEdit && teamData) {
            setFormData({
                content: teamData.content || '',
            });
            if (teamData.media && Array.isArray(teamData.media)) {
                const images = teamData.media.map((img: any) => ({
                    id: img._id || img.id,
                    name: img.name || 'image',
                    type: img.mimetype || '',
                    url: img.path,
                }));
                setExistingImages(images);
            }
        }
    }, [isEdit, teamData]);

    const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value,
        });
    };

    const uploadImages = async (files: FileList) => {
        setUploading(true);
        const filesArray = Array.from(files);
        const newUploadedImages = filesArray.map((file, index) => ({
            id: `temp-${Date.now()}-${index}`,
            name: file.name,
            type: file.type,
            url: URL.createObjectURL(file),
            file: file,
        }));
        setUploadedImages((prev) => [...prev, ...newUploadedImages]);
        setUploading(false);
    };

    const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files && e.target.files.length > 0) {
            uploadImages(e.target.files);
        }
    };

    const removeImage = (imageId: string, imageType: 'existing' | 'uploaded' = 'uploaded') => {
        if (imageType === 'existing') {
            const imageToRemove = existingImages.find(img => img.id === imageId);
            if (imageToRemove) {
                setExistingImages(prev => prev.filter(img => img.id !== imageId));
                setDeletedImages(prev => [...prev, imageToRemove.id]);
            }
        } else {
            const imageToRemove = uploadedImages.find(img => img.id === imageId);
            if (imageToRemove && imageToRemove.url.startsWith('blob:')) {
                URL.revokeObjectURL(imageToRemove.url);
            }
            setUploadedImages(prev => prev.filter(img => img.id !== imageId));
        }
    };

    useEffect(() => {
        return () => {
            uploadedImages.forEach(img => {
                if (img.url.startsWith('blob:')) {
                    URL.revokeObjectURL(img.url);
                }
            });
        };
    }, [uploadedImages]);

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        if (isEdit && teamData) {
            const updatePayload = {
                _id: teamData._id || teamData.id,
                type: teamType,
                content: formData.content,
                ...(deletedImages.length > 0 && { deleteIds: deletedImages }),
                ...(uploadedImages.length > 0 && {
                    files: uploadedImages.map(m => m.file).filter(Boolean),
                }),
            };
            dispatch({ type: 'UPDATE_TEAM_REQUEST', payload: updatePayload });
        } else {
            const createPayload = {
                type: teamType,
                content: formData.content,
                ...(uploadedImages.length > 0 && {
                    files: uploadedImages.map(m => m.file).filter(Boolean),
                }),
            };
            dispatch({ type: 'CREATE_TEAM_REQUEST', payload: createPayload });
        }
    };

    return (
        <div className="flex flex-col h-full">
            {/* Scrollable content area */}
            <div className="flex-1 overflow-y-auto space-y-4 pr-2 p-4">
                {/* Basic Information */}
                <Card>
                    <CardHeader>
                        <CardTitle>{teamType.charAt(0).toUpperCase() + teamType.slice(1)}</CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-4">
                        {/* <div>
                            <Label htmlFor="content">Content</Label>
                            <CKEditorWrapper
                                data={formData.content}
                                onChange={val => setFormData(f => ({ ...f, content: val }))}
                            />
                        </div> */}

                        <div>
                            <Label htmlFor="content">Content</Label>
                            <TinyMCEWrapper
                                data={formData.content}
                                onChange={val => setFormData(f => ({ ...f, content: val }))}
                            />
                        </div>
                    </CardContent>
                </Card>

                {/* Image Upload Section */}
                <Card>
                    <CardHeader>
                        <CardTitle className="text-lg">Images</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <CommonFileUpload
                            existingFiles={existingImages}
                            uploadedFiles={uploadedImages}
                            onUpload={uploadImages}
                            onRemove={removeImage}
                            isEdit={isEdit}
                            uploading={uploading}
                            labelExisting="Existing Images"
                            labelNew="Newly Uploaded Images"
                            accept="image/*"
                            dragText="Click to upload or drag and drop"
                            uploadText="Images"
                        />
                    </CardContent>
                </Card>
            </div>

            {/* Fixed action buttons at the bottom */}
            <div className="flex justify-end space-x-4 px-4 py-3 border-t bg-white">
                <Button
                    type="button"
                    variant="outline"
                    onClick={onClose}
                    disabled={loading || uploading}
                >
                    Cancel
                </Button>
                <Button
                    type="submit"
                    className="bg-nepal-blue hover:bg-nepal-blue/90"
                    disabled={loading || uploading}
                    onClick={handleSubmit}
                >
                    {loading ? (
                        <>
                            <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                            {isEdit ? 'Updating...' : 'Creating...'}
                        </>
                    ) : (
                        isEdit ? 'Update Team' : 'Create Team'
                    )}
                </Button>
            </div>
        </div>
    );
}
