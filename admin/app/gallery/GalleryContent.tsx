'use client'

import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from '@/components/ui/table'
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from '@/components/ui/dialog'
import { Plus, Edit, Trash2, Image, ChevronLeft, ChevronRight } from 'lucide-react'
import { RootState } from '@/lib/redux/store'
import { PopConfirmDeleteIconBtn } from '../../components/buttons/iconBtns'
import AddUpdateGalleryForm from './AddUpdateGalleryForm'
import imageUrl from '@/lib/helpers/baseUrls'
import ModalDialogWrapper from '../../components/ModalDialogWrapper'

export default function GalleryContent() {
    const dispatch = useDispatch()
    const { galleries, isLoading, page, totalPages, selectedGallery, deleteSuccess, createUpdateSuccess, total } = useSelector((state: RootState) => state.galleryReducer)
    const [showAddForm, setShowAddForm] = useState(false)
    const [showEditForm, setShowEditForm] = useState(false)

    const handlePageChange = (newPage: number) => {
        dispatch({
            type: 'SET_GALLERY_PAGE',
            payload: { page: newPage }
        })
    }

    useEffect(() => {
        dispatch({ type: 'FETCH_GALLERY_REQUEST', payload: {} })
    }, [dispatch, page])

    useEffect(() => {
        if (createUpdateSuccess) {
            setShowAddForm(false)
            setShowEditForm(false)
            dispatch({ type: 'FETCH_GALLERY_REQUEST', payload: {} })
        }
    }, [createUpdateSuccess, dispatch])

    useEffect(() => {
        if (deleteSuccess) {
            dispatch({ type: 'FETCH_GALLERY_REQUEST', payload: {} })
        }
    }, [deleteSuccess, dispatch])

    const handleDelete = (galleryId: string) => {
        dispatch({ type: 'DELETE_GALLERY_REQUEST', payload: galleryId })
    }

    const handleEdit = (gallery: any) => {
        dispatch({ type: 'SET_SELECTED_GALLERY', payload: gallery })
        setShowEditForm(true)
    }

    return (
        <div className="space-y-6">
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                <div>
                    <h1 className="text-2xl font-bold nepal-blue">Gallery Management</h1>
                    <p className="text-gray-600">Manage gallery images and videos</p>
                </div>
                <Button onClick={() => setShowAddForm(true)} className="bg-nepal-red hover:bg-nepal-red/90" disabled={isLoading}>
                    <Plus className="mr-2 h-4 w-4" />
                    Create New Gallery
                </Button>
                <ModalDialogWrapper
                    onCloseHandler={() => {
                        setShowAddForm(false)
                        setShowEditForm(false)
                    }}
                    open={showAddForm || showEditForm}
                    setOpen={setShowAddForm || setShowEditForm}
                    title={showEditForm ? 'Edit Gallery' : 'Create New Gallery'}
                    subTitle='Manage your gallery images and videos'
                >
                    <AddUpdateGalleryForm onClose={() => {
                        setShowAddForm(false)
                        setShowEditForm(false)
                    }} isEdit={showEditForm} galleryData={selectedGallery} />
                </ModalDialogWrapper>

            </div>
            <Card className="border mb-2">
                {/* No filters for gallery, but you can add if needed */}
            </Card>
            <Card>
                <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                        <Image className="h-5 w-5" />
                        Gallery ({total || 0})
                    </CardTitle>
                </CardHeader>
                <CardContent>
                    {isLoading ? (
                        <div className="flex justify-center items-center py-8">
                            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-nepal-blue"></div>
                        </div>
                    ) : (
                        <>
                            <div className="overflow-x-auto">
                                <Table>
                                    <TableHeader>
                                        <TableRow>
                                            <TableHead>Title</TableHead>
                                            <TableHead>Medias</TableHead>
                                            <TableHead className="text-right">Actions</TableHead>
                                        </TableRow>
                                    </TableHeader>
                                    <TableBody>
                                        {galleries && galleries.length === 0 ? (
                                            <TableRow>
                                                <TableCell colSpan={3} className="text-center text-gray-500 py-8">
                                                    No gallery items found.
                                                </TableCell>
                                            </TableRow>
                                        ) : (
                                            galleries.map((gallery: any) => (
                                                <TableRow key={gallery._id || gallery.id}>
                                                    <TableCell>
                                                        <div className="font-medium">{gallery.title}</div>
                                                    </TableCell>
                                                    <TableCell>
                                                        <div className="flex gap-2 flex-wrap">
                                                            {gallery.medias && gallery.medias.length > 0 && (
                                                                <div className="relative h-12 w-12">
                                                                    <img
                                                                        src={imageUrl + gallery.medias[0].path}
                                                                        alt="media"
                                                                        className="h-12 w-12 rounded object-cover"
                                                                    />
                                                                    {gallery.medias.length > 1 && (
                                                                        <div className="absolute -right-2 -bottom-2 bg-black bg-opacity-70 text-white text-xs rounded-full px-2 py-0.5 border border-white">
                                                                            +{gallery.medias.length - 1}
                                                                        </div>
                                                                    )}
                                                                </div>
                                                            )}
                                                        </div>
                                                    </TableCell>
                                                    <TableCell className="text-right">
                                                        <div className="flex justify-end gap-2">
                                                            <Button
                                                                variant="outline"
                                                                size="sm"
                                                                onClick={() => handleEdit(gallery)}
                                                            >
                                                                <Edit className="h-4 w-4" />
                                                            </Button>
                                                            <PopConfirmDeleteIconBtn
                                                                onConfirm={() => handleDelete(gallery._id || gallery.id)}
                                                            />
                                                        </div>
                                                    </TableCell>
                                                </TableRow>
                                            ))
                                        )}
                                    </TableBody>
                                </Table>
                            </div>
                            {galleries && galleries.length > 0 && totalPages && totalPages > 1 && (
                                <div className="flex items-center justify-between mt-4">
                                    <div className="text-sm text-gray-500">
                                        Page {page} of {totalPages}
                                    </div>
                                    <div className="flex gap-2">
                                        <Button
                                            variant="outline"
                                            size="sm"
                                            onClick={() => handlePageChange(page - 1)}
                                            disabled={page === 1}
                                        >
                                            <ChevronLeft className="h-4 w-4" />
                                            Previous
                                        </Button>
                                        <Button
                                            variant="outline"
                                            size="sm"
                                            onClick={() => handlePageChange(page + 1)}
                                            disabled={page === totalPages}
                                        >
                                            Next
                                            <ChevronRight className="h-4 w-4" />
                                        </Button>
                                    </div>
                                </div>
                            )}
                        </>
                    )}
                </CardContent>
            </Card>
        </div>
    )
}
