'use client'

import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Upload, X, FileText, Image, Video } from 'lucide-react'
import { RootState } from '@/lib/redux/store'
import dayjs from 'dayjs'
import CKEditorWrapper from '@/components/CKEditorWrapper'
import { CommonFileUpload, UploadedFile, ExistingFile } from '@/components/form-items/common-file-upload'



interface AddUpdateEventsFormProps {
  onClose: () => void
  isEdit?: boolean
  eventData?: any
}

export default function AddUpdateEventsForm({ onClose, isEdit = false, eventData }: AddUpdateEventsFormProps) {
  const dispatch = useDispatch()
  const { isLoading, message, error, createUpdateSuccess } = useSelector((state: RootState) => state.eventReducer)

  const [formData, setFormData] = useState({
    title: '',
    description: '',
    date: '',
  })
  const [uploadedFiles, setUploadedFiles] = useState<UploadedFile[]>([]) // Only newly uploaded files
  const [existingFiles, setExistingFiles] = useState<ExistingFile[]>([]) // Files that already exist in the event
  const [uploading, setUploading] = useState(false)
  const [deletedFiles, setDeletedFiles] = useState<string[]>([])







  // Initialize form data for edit mode
  useEffect(() => {
    if (isEdit && eventData) {
      setFormData({
        title: eventData.title || '',
        description: eventData.description || '',
        date: eventData.date || '',
      })

      // Handle existing files separately - don't add to uploadedFiles
      const existingFilesArray: ExistingFile[] = []

      // Add media files (images/videos)
      if (eventData.media && Array.isArray(eventData.media)) {
        const mediaFiles = eventData.media.map((mediaItem: any) => ({
          id: mediaItem._id,
          name: `${mediaItem.type}`,
          type: mediaItem.mimetype,
          url: mediaItem.path,
          category: 'media' as const
        }))
        existingFilesArray.push(...mediaFiles)
      }

      // Add document files
      if (eventData.documents && Array.isArray(eventData.documents)) {
        const documentFiles = eventData.documents.map((doc: any) => ({
          id: doc._id,
          name: `${doc.mimetype.split('/')[1]}document`,
          type: doc.mimetype,
          url: doc.path,
          category: 'document' as const
        }))
        existingFilesArray.push(...documentFiles)
      }

      setExistingFiles(existingFilesArray)
    }
  }, [isEdit, eventData])

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  const uploadFiles = async (files: FileList) => {
    setUploading(true);

    const filesArray = Array.from(files);

    // Add files directly to uploadedFiles state with the actual File objects
    const newUploadedFiles = filesArray.map((file, index) => ({
      id: `temp-${Date.now()}-${index}`, // Temporary ID for display
      name: file.name,
      type: file.type,
      url: URL.createObjectURL(file), // Create preview URL
      file: file // Store the actual File object
    }));

    setUploadedFiles((prev) => [...prev, ...newUploadedFiles]);
    setUploading(false);
  };


  const handleFileUpload = (files: FileList) => {
    if (files && files.length > 0) {
      uploadFiles(files);
    }
  };
  const removeFile = (fileId: string, fileType: 'existing' | 'uploaded' = 'uploaded') => {
    if (fileType === 'existing') {
      // Removing an existing file from the event
      const fileToRemove = existingFiles.find(file => file.id === fileId);
      if (fileToRemove) {
        setExistingFiles(prev => prev.filter(file => file.id !== fileId))
        setDeletedFiles(prev => [...prev, fileToRemove.id])
      }
    } else {
      // Removing a newly uploaded file
      const fileToRemove = uploadedFiles.find(file => file.id === fileId);
      if (fileToRemove && fileToRemove.url.startsWith('blob:')) {
        // Clean up the object URL to prevent memory leaks
        URL.revokeObjectURL(fileToRemove.url);
      }
      setUploadedFiles(prev => prev.filter(file => file.id !== fileId))
    }
  }

  // Clean up object URLs when component unmounts
  useEffect(() => {
    return () => {
      uploadedFiles.forEach(file => {
        if (file.url.startsWith('blob:')) {
          URL.revokeObjectURL(file.url);
        }
      });
    };
  }, [uploadedFiles])


  const getFileIcon = (type: string) => {
    if (type.startsWith('image/')) return <Image className="h-4 w-4" />
    if (type.startsWith('video/')) return <Video className="h-4 w-4" />
    return <FileText className="h-4 w-4" />
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()

    // Validate required fields
    if (!formData.title.trim()) {
      alert('Please enter an event title');
      return;
    }

    if (!formData.date) {
      alert('Please select an event date');
      return;
    }

    if (isEdit && eventData) {
      // Update existing event
      const updatePayload = {
        _id: eventData._id || eventData.id,
        title: formData.title,
        description: formData.description,
        date: formData.date,
        ...(deletedFiles.length > 0 && { deleteIds: deletedFiles }), // Only include deleteIds if there are files to delete
        ...(uploadedFiles.length > 0 && {
          files: uploadedFiles.map(f => f.file).filter(Boolean) // Pass only the File objects
        }),
      }

      dispatch({ type: 'UPDATE_EVENT_REQUEST', payload: updatePayload })
      console.log('Updating event:', updatePayload)
    } else {
      // Create new event
      const createPayload = {
        title: formData.title,
        description: formData.description,
        date: formData.date,
        ...(uploadedFiles.length > 0 && {
          files: uploadedFiles.map(f => f.file).filter(Boolean) // Pass only the File objects
        }),
      }

      dispatch({ type: 'CREATE_EVENT_REQUEST', payload: createPayload })
      console.log('Creating event:', createPayload)
    }
  }

  return (
    <div className="flex flex-col h-full">
      {/* Scrollable content area */}
      <div className="flex-1 overflow-y-auto space-y-6 pr-2 p-6">
        {/* Basic Information */}
        <Card>
          <CardHeader>
            <CardTitle className="text-lg">Information</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label htmlFor="title">Event Title</Label>
              <Input
                id="title"
                name="title"
                value={formData.title}
                onChange={handleInputChange}
                placeholder="Enter event title"
                required
              />
            </div>

            <div>
              <Label htmlFor="date">Event Date & Time</Label>
              <Input
                id="date"
                name="date"
                type="datetime-local"
                value={formData.date && dayjs(formData.date).isValid() ? dayjs(formData.date).format('YYYY-MM-DDTHH:mm') : ''}
                onChange={handleInputChange}
                required
              />
            </div>

            <div>
              <Label htmlFor="description">Description</Label>
              <CKEditorWrapper
                data={formData.description}
                onChange={(data: string) => {
                  setFormData(prev => ({
                    ...prev,
                    description: data,
                  }));
                }}
              />
            </div>
          </CardContent>
        </Card>

        {/* File Upload Section */}
        <Card>
          <CardHeader>
            <CardTitle className="text-lg">Media & Documents</CardTitle>
          </CardHeader>
          <CardContent>
            <CommonFileUpload
              existingFiles={existingFiles}
              uploadedFiles={uploadedFiles}
              onUpload={handleFileUpload}
              onRemove={removeFile}
              isEdit={isEdit}
              uploading={uploading}
              labelExisting="Existing Files"
              labelNew="Newly Uploaded Files"
              accept="image/*,video/*,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document"
              dragText="Click to upload or drag and drop"
              uploadText="Images, Videos, PDFs, DOCX files"
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
            isEdit ? 'Update Event' : 'Create Event'
          )}
        </Button>
      </div>
    </div>
  )
}
