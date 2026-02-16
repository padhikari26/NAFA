"use client"

import React from "react"
import { Upload, X, ImageIcon, Video, FileScan, FileText, Eye } from "lucide-react"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Label } from "@/components/ui/label" // Fixed import path
import imageUrl from "@/lib/helpers/baseUrls"
import { openNotificationWithIcon } from "@/lib/helpers/notification"

export interface UploadedFile {
    id: string
    name: string
    type: string
    url: string
    file?: File
}

export interface ExistingFile {
    id: string
    name: string
    type: string
    url: string
    category: "media" | "document"
}

export interface CommonFileUploadProps {
    existingFiles?: Array<ExistingFile>
    uploadedFiles?: Array<UploadedFile>
    onUpload: (files: FileList) => void
    onRemove: (id: string, type: "existing" | "uploaded") => void
    isEdit?: boolean
    uploading?: boolean
    labelExisting?: string
    labelNew?: string
    accept?: string
    dragText?: string
    uploadText?: string
    maxFiles?: number
}

const getFileIcon = (type: string) => {
    if (type.startsWith("image/")) return <ImageIcon className="h-5 w-5 text-blue-600" />
    if (type.startsWith("video/")) return <Video className="h-5 w-5 text-purple-600" />
    if (type.includes("pdf")) return <FileText className="h-5 w-5 text-red-600" />
    if (type.includes("word") || type.includes("document")) return <FileText className="h-5 w-5 text-blue-700" />
    return <FileScan className="h-5 w-5 text-gray-600" />
}


// File size limits in bytes
const FILE_SIZE_LIMITS = {
    IMAGE: 10 * 1024 * 1024, // 10 MB
    VIDEO: 100 * 1024 * 1024, // 100 MB
    DOCUMENT: 10 * 1024 * 1024, // 10 MB (for PDFs, DOCX, etc.)
}

const validateFileSize = (file: File): { isValid: boolean; message?: string } => {
    const fileType = file.type.toLowerCase()
    let maxSize: number
    let fileTypeLabel: string

    if (fileType.startsWith('image/')) {
        maxSize = FILE_SIZE_LIMITS.IMAGE
        fileTypeLabel = 'image'
    } else if (fileType.startsWith('video/')) {
        maxSize = FILE_SIZE_LIMITS.VIDEO
        fileTypeLabel = 'video'
    } else {
        maxSize = FILE_SIZE_LIMITS.DOCUMENT
        fileTypeLabel = 'document'
    }

    if (file.size > maxSize) {
        const maxSizeMB = Math.round(maxSize / (1024 * 1024))
        const fileSizeMB = (file.size / (1024 * 1024)).toFixed(1)
        return {
            isValid: false,
            message: `${file.name} (${fileSizeMB}MB) exceeds the ${maxSizeMB}MB limit for ${fileTypeLabel}s.`
        }
    }

    return { isValid: true }
}

export const CommonFileUpload: React.FC<CommonFileUploadProps> = ({
    existingFiles = [],
    uploadedFiles = [],
    onUpload,
    onRemove,
    isEdit = false,
    uploading = false,
    labelExisting = "Existing Files",
    labelNew = "Newly Uploaded Files",
    accept = "image/*,video/*,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    dragText = "Click to upload or drag and drop",
    uploadText = "Images, Videos, PDFs, DOCX files",
    maxFiles = 50,
}) => {
    const [isDragOver, setIsDragOver] = React.useState(false)

    const handleFileValidationAndUpload = (files: FileList) => {
        const filesArray = Array.from(files)
        const currentFileCount = existingFiles.length + uploadedFiles.length
        const validFiles: File[] = []
        const invalidFiles: string[] = []

        // Check if adding new files would exceed the limit
        if (currentFileCount + filesArray.length > maxFiles) {
            const remainingSlots = maxFiles - currentFileCount
            openNotificationWithIcon('error', `You can only upload ${remainingSlots} more file${remainingSlots !== 1 ? 's' : ''}. Maximum ${maxFiles} files allowed.`)

            // Only process files up to the limit
            if (remainingSlots > 0) {
                filesArray.splice(remainingSlots)
            } else {
                return // Don't process any files if already at limit
            }
        }

        // Validate each file for size
        filesArray.forEach(file => {
            const validation = validateFileSize(file)
            if (validation.isValid) {
                validFiles.push(file)
            } else {
                invalidFiles.push(validation.message!)
            }
        })

        // Show error messages for invalid files
        if (invalidFiles.length > 0) {
            invalidFiles.forEach(message => {
                openNotificationWithIcon('error', message)
            })
        }

        // Upload valid files if any
        if (validFiles.length > 0) {
            const dataTransfer = new DataTransfer()
            validFiles.forEach(file => dataTransfer.items.add(file))
            onUpload(dataTransfer.files)
        }
    }

    const handleDragOver = (e: React.DragEvent) => {
        e.preventDefault()
        setIsDragOver(true)
    }

    const handleDragLeave = (e: React.DragEvent) => {
        e.preventDefault()
        setIsDragOver(false)
    }

    const handleDrop = (e: React.DragEvent) => {
        e.preventDefault()
        setIsDragOver(false)
        if (e.dataTransfer.files) {
            handleFileValidationAndUpload(e.dataTransfer.files)
        }
    }

    return (
        <div className="space-y-8">
            <div className="relative">
                {(() => {
                    const currentFileCount = existingFiles.length + uploadedFiles.length
                    const isAtLimit = currentFileCount >= maxFiles

                    return (
                        <label
                            className={`
                                flex flex-col items-center justify-center w-full min-h-44 py-6
                                border-2 border-dashed rounded-xl cursor-pointer 
                                transition-all duration-300 ease-in-out
                                ${isDragOver && !isAtLimit
                                    ? "border-blue-500 bg-blue-50 scale-[1.02]"
                                    : isAtLimit
                                        ? "border-gray-200 bg-gray-50 cursor-not-allowed opacity-60"
                                        : "border-gray-300 bg-gradient-to-br from-gray-50 to-white hover:border-blue-400 hover:bg-blue-50/50"
                                }
                                ${uploading ? "pointer-events-none opacity-60" : ""}
                            `}
                            onDragOver={!isAtLimit ? handleDragOver : undefined}
                            onDragLeave={!isAtLimit ? handleDragLeave : undefined}
                            onDrop={!isAtLimit ? handleDrop : undefined}
                        >
                            <div className="flex flex-col items-center justify-center px-4 text-center">
                                <div
                                    className={`
                                    p-3 rounded-full mb-3 transition-all duration-300
                                    ${isDragOver && !isAtLimit ? "bg-blue-100 scale-110" : "bg-gray-100"}
                                `}
                                >
                                    <Upload
                                        className={`
                                        w-6 h-6 transition-colors duration-300
                                        ${isDragOver && !isAtLimit ? "text-blue-600" : isAtLimit ? "text-gray-400" : "text-gray-500"}
                                    `}
                                    />
                                </div>
                                <p className={`mb-2 text-sm font-semibold ${isAtLimit ? "text-gray-400" : "text-gray-700"}`}>
                                    {isAtLimit ? "File limit reached" : dragText.split(" or ")[0]}{" "}
                                    {!isAtLimit && <span className="font-normal text-gray-500">or {dragText.split(" or ")[1]}</span>}
                                </p>
                                <p className={`text-xs max-w-xs mb-2 ${isAtLimit ? "text-gray-400" : "text-gray-500"}`}>
                                    {isAtLimit ? "Remove files to upload more" : uploadText}
                                </p>
                                <div className="text-xs text-gray-400">
                                    <p className="mb-1">Size limits: Images (10MB), Videos (100MB), Documents (10MB)</p>
                                    <p className={`${isAtLimit ? "text-red-500 font-medium" : ""}`}>
                                        Files: {currentFileCount}/{maxFiles}
                                    </p>
                                </div>
                            </div>
                            <input
                                type="file"
                                multiple
                                onChange={(e) => e.target.files && handleFileValidationAndUpload(e.target.files)}
                                accept={accept}
                                className="hidden"
                                disabled={uploading || isAtLimit}
                            />
                        </label>
                    )
                })()}

                {uploading && (
                    <div className="absolute inset-0 bg-white/80 backdrop-blur-sm rounded-xl flex items-center justify-center">
                        <div className="flex items-center space-x-3">
                            <div className="animate-spin rounded-full h-8 w-8 border-3 border-blue-200 border-t-blue-600"></div>
                            <span className="text-base font-medium text-gray-700">Uploading files...</span>
                        </div>
                    </div>
                )}
            </div>

            {isEdit && existingFiles.length > 0 && (
                <div className="space-y-3">
                    <div className="flex items-center justify-between">
                        <Label className="text-lg font-semibold text-gray-800">{labelExisting}</Label>
                        <Badge variant="secondary" className="bg-blue-100 text-blue-800 font-medium">
                            {existingFiles.length} file{existingFiles.length !== 1 ? "s" : ""}
                        </Badge>
                    </div>
                    <div className="grid gap-3">
                        {existingFiles.map((file) => (
                            <div
                                key={file.id}
                                className="group relative bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-all duration-200 hover:border-gray-300"
                            >
                                <div className="flex items-center space-x-4">
                                    {file.type.startsWith("image/") ? (
                                        <div className="relative">
                                            <img
                                                src={imageUrl + file.url || "/placeholder.svg"}
                                                alt={file.name}
                                                className="w-16 h-16 object-cover rounded-lg border border-gray-200"
                                            />
                                            <div className="absolute inset-0 bg-black/0 group-hover:bg-black/10 rounded-lg transition-colors duration-200"></div>
                                        </div>
                                    ) : (
                                        <div className="w-16 h-16 bg-gray-50 rounded-lg border border-gray-200 flex items-center justify-center">
                                            {getFileIcon(file.type)}
                                        </div>
                                    )}

                                    <div className="flex-1 min-w-0">
                                        <p className="text-sm font-semibold text-gray-900 truncate">{file.name}</p>
                                        <p className="text-xs text-gray-500 mt-1">Existing file</p>
                                    </div>

                                    <div className="flex items-center space-x-2">
                                        <Button
                                            type="button"
                                            variant="ghost"
                                            size="sm"
                                            className="h-8 w-8 p-0 hover:bg-blue-50 hover:text-blue-600"
                                            onClick={() => window.open(imageUrl + file.url, "_blank")}
                                        >
                                            <Eye className="h-4 w-4" />
                                        </Button>
                                        <Button
                                            type="button"
                                            variant="ghost"
                                            size="sm"
                                            className="h-8 w-8 p-0 hover:bg-red-50 hover:text-red-600"
                                            onClick={() => onRemove(file.id, "existing")}
                                        >
                                            <X className="h-4 w-4" />
                                        </Button>
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {uploadedFiles.length > 0 && (
                <div className="space-y-3">
                    <div className="flex items-center justify-between">
                        <Label className="text-lg font-semibold text-gray-800">{labelNew}</Label>
                        <Badge variant="secondary" className="bg-green-100 text-green-800 font-medium">
                            {uploadedFiles.length} new file{uploadedFiles.length !== 1 ? "s" : ""}
                        </Badge>
                    </div>
                    <div className="grid gap-3">
                        {uploadedFiles.map(({ id, file }) => (
                            <div
                                key={id}
                                className="group relative bg-gradient-to-r from-green-50 to-emerald-50 border border-green-200 rounded-lg p-4 hover:shadow-md transition-all duration-200"
                            >
                                <div className="flex items-center space-x-4">
                                    {file ? (
                                        <>
                                            {file.type.startsWith("image/") ? (
                                                <div className="relative">
                                                    <img
                                                        src={URL.createObjectURL(file) || "/placeholder.svg"}
                                                        alt={file.name}
                                                        className="w-16 h-16 object-cover rounded-lg border border-green-200"
                                                    />
                                                    <div className="absolute inset-0 bg-black/0 group-hover:bg-black/10 rounded-lg transition-colors duration-200"></div>
                                                </div>
                                            ) : file.type.startsWith("video/") ? (
                                                <div className="relative">
                                                    <video
                                                        src={URL.createObjectURL(file)}
                                                        className="w-16 h-16 object-cover rounded-lg border border-green-200"
                                                    />
                                                    <div className="absolute inset-0 bg-black/20 rounded-lg flex items-center justify-center">
                                                        <Video className="h-6 w-6 text-white" />
                                                    </div>
                                                </div>
                                            ) : (
                                                <div className="w-16 h-16 bg-white rounded-lg border border-green-200 flex items-center justify-center">
                                                    {getFileIcon(file.type)}
                                                </div>
                                            )}

                                            <div className="flex-1 min-w-0">
                                                <p className="text-sm font-semibold text-gray-900 truncate">{file.name}</p>
                                                {/* <p className="text-xs text-gray-500 mt-1">
                                                    {formatFileSize(file.size)} • {file.type.split("/")[1]?.toUpperCase()}
                                                </p> */}
                                            </div>

                                            <Badge variant="secondary" className="bg-green-100 text-green-700 text-xs font-medium">
                                                NEW
                                            </Badge>
                                        </>
                                    ) : (
                                        <div className="flex-1">
                                            <span className="text-gray-500 text-sm">No file data available</span>
                                        </div>
                                    )}

                                    <Button
                                        type="button"
                                        variant="ghost"
                                        size="sm"
                                        className="h-8 w-8 p-0 hover:bg-red-50 hover:text-red-600"
                                        onClick={() => onRemove(id, "uploaded")}
                                    >
                                        <X className="h-4 w-4" />
                                    </Button>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            )}
        </div>
    )
}
