import { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { CommonFileUpload, UploadedFile, ExistingFile } from '@/components/form-items/common-file-upload';
import { RootState } from '@/lib/redux/store';
import { Label } from '@/components/ui/label';



interface AddUpdateGalleryFormProps {
    onClose: () => void;
    isEdit?: boolean;
    galleryData?: any;
}


export default function AddUpdateGalleryForm({ onClose, isEdit = false, galleryData }: AddUpdateGalleryFormProps) {
    const dispatch = useDispatch();
    const { isLoading, createUpdateSuccess } = useSelector((state: RootState) => state.galleryReducer);

    const [formData, setFormData] = useState({
        title: '',
    });
    const [uploadedMedias, setUploadedMedias] = useState<UploadedFile[]>([]);
    const [existingMedias, setExistingMedias] = useState<ExistingFile[]>([]);
    const [uploading, setUploading] = useState(false);
    const [deletedMedias, setDeletedMedias] = useState<string[]>([]);

    useEffect(() => {
        if (isEdit && galleryData) {
            setFormData({
                title: galleryData.title || '',
            });
            if (galleryData.medias && Array.isArray(galleryData.medias)) {
                const mediaFiles = galleryData.medias.map((mediaItem: any) => ({
                    id: mediaItem._id || mediaItem.id,
                    name: mediaItem.name || 'media',
                    type: mediaItem.mimetype || '',
                    url: mediaItem.url || mediaItem.path,
                    category: 'media',
                }));
                setExistingMedias(mediaFiles);
            }
        }
    }, [isEdit, galleryData]);

    const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value,
        });
    };

    const removeMedia = (mediaId: string, mediaType: 'existing' | 'uploaded' = 'uploaded') => {
        if (mediaType === 'existing') {
            const mediaToRemove = existingMedias.find(media => media.id === mediaId);
            if (mediaToRemove) {
                setExistingMedias(prev => prev.filter(media => media.id !== mediaId));
                setDeletedMedias(prev => [...prev, mediaToRemove.id]);
            }
        } else {
            const mediaToRemove = uploadedMedias.find(media => media.id === mediaId);
            if (mediaToRemove && mediaToRemove.url.startsWith('blob:')) {
                URL.revokeObjectURL(mediaToRemove.url);
            }
            setUploadedMedias(prev => prev.filter(media => media.id !== mediaId));
        }
    };

    useEffect(() => {
        return () => {
            uploadedMedias.forEach(media => {
                if (media.url.startsWith('blob:')) {
                    URL.revokeObjectURL(media.url);
                }
            });
        };
    }, [uploadedMedias]);

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        if (!formData.title.trim()) {
            alert('Please enter a gallery title');
            return;
        }
        if (isEdit && galleryData) {
            const updatePayload = {
                _id: galleryData._id || galleryData.id,
                title: formData.title,
                ...(deletedMedias.length > 0 && { deleteIds: deletedMedias }),
                ...(uploadedMedias.length > 0 && {
                    files: uploadedMedias.map(m => m.file).filter(Boolean),
                }),
            };
            dispatch({ type: 'UPDATE_GALLERY_REQUEST', payload: updatePayload });
        } else {
            const createPayload = {
                title: formData.title,
                ...(uploadedMedias.length > 0 && {
                    files: uploadedMedias.map(m => m.file).filter(Boolean),
                }),
            };
            dispatch({ type: 'CREATE_GALLERY_REQUEST', payload: createPayload });
        }
    };

    return (
        <div className="flex flex-col h-full">
            {/* Scrollable content area */}
            <div className="flex-1 overflow-y-auto space-y-6 pr-2 p-6">
                <Card>
                    <CardHeader>
                        <CardTitle className="text-lg">Gallery Title</CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-4">
                        <div>
                            <Input
                                id="title"
                                name="title"
                                value={formData.title}
                                onChange={handleInputChange}
                                placeholder="Enter gallery title"
                                required
                            />
                        </div>
                    </CardContent>
                </Card>

                <Card>
                    <CardHeader>
                        <CardTitle className="text-lg">Media</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <CommonFileUpload
                            existingFiles={existingMedias}
                            uploadedFiles={uploadedMedias}
                            onUpload={files => {
                                if (files && files.length > 0) {
                                    const filesArray = Array.from(files);
                                    const newUploadedMedias = filesArray.map((file, index) => ({
                                        id: `temp-${Date.now()}-${index}`,
                                        name: file.name,
                                        type: file.type,
                                        url: URL.createObjectURL(file),
                                        file: file,
                                    }));
                                    setUploadedMedias(prev => [...prev, ...newUploadedMedias]);
                                }
                            }}
                            onRemove={removeMedia}
                            isEdit={isEdit}
                            uploading={uploading}
                            labelExisting="Existing Medias"
                            labelNew="Newly Uploaded Medias"
                            accept="image/*,video/*"
                            dragText="Click to upload or drag and drop"
                            uploadText="Images, Videos"
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
                    disabled={isLoading || uploading}
                >
                    Cancel
                </Button>
                <Button
                    type="submit"
                    className="bg-nepal-blue hover:bg-nepal-blue/90"
                    disabled={isLoading || uploading}
                    onClick={handleSubmit}
                >
                    {isLoading ? (
                        <>
                            <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                            {isEdit ? 'Updating...' : 'Creating...'}
                        </>
                    ) : (
                        isEdit ? 'Update Gallery' : 'Create Gallery'
                    )}
                </Button>
            </div>
        </div>
    );
}
