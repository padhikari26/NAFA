"use client"

import { useEffect, useState } from "react"
import { useSelector, useDispatch } from "react-redux"
import type { RootState, AppDispatch } from "../../lib/redux/store"
import { Card, CardHeader, CardTitle, CardContent } from "../../components/ui/card"
import { Button } from "../../components/ui/button"
import { ImageIcon, Edit, Plus } from "lucide-react"
import ModalDialogWrapper from "../../components/ModalDialogWrapper"
import { BannerForm } from "./BannerForm"
import imageUrl from "@/lib/helpers/baseUrls"

export default function BannerContent() {
    const [showModal, setShowModal] = useState(false)
    const dispatch = useDispatch<AppDispatch>()

    const { bannerLoading, bannerSuccess, banner } = useSelector((state: RootState) => state.commonReducer)

    useEffect(() => {
        dispatch({ type: "GET_BANNER_REQUEST" })
    }, [dispatch])
    useEffect(() => {
        if (bannerSuccess) {
            setShowModal(false)
            dispatch({ type: "GET_BANNER_REQUEST" })
        }
    }, [bannerSuccess, dispatch])

    const formatDate = (dateString: string) => {
        return new Date(dateString).toLocaleDateString("en-US", {
            year: "numeric",
            month: "short",
            day: "numeric",
            hour: "2-digit",
            minute: "2-digit",
        })
    }

    return (
        <Card className="border-nepal-blue/20">
            <CardHeader className="bg-nepal-blue/5">
                <CardTitle className="flex items-center gap-2 text-nepal-blue">
                    <ImageIcon className="h-5 w-5" /> Banner Management
                </CardTitle>
            </CardHeader>
            <CardContent className="pt-6">
                {banner ? (
                    <div className="space-y-4">
                        <div className="flex flex-col md:flex-row items-start gap-6 p-4 bg-gray-50 rounded-lg border border-nepal-blue/10">
                            <div className="flex-1 space-y-3">
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div className="flex flex-col gap-1">
                                        <span className="text-sm font-medium text-gray-600">Start Date</span>
                                        <span className="text-nepal-blue font-semibold">{formatDate(banner.startDate)}</span>
                                    </div>
                                    <div className="flex flex-col gap-1">
                                        <span className="text-sm font-medium text-gray-600">End Date</span>
                                        <span className="text-nepal-blue font-semibold">{formatDate(banner.endDate)}</span>
                                    </div>
                                </div>
                            </div>
                            <div className="flex flex-col items-center gap-3">
                                <img
                                    src={imageUrl + banner.media?.path || "/placeholder-logo.png"}
                                    alt="banner"
                                    className="h-24 w-24 object-cover rounded-lg border-2 border-nepal-blue/20"
                                />
                                <Button
                                    variant="outline"
                                    onClick={() => setShowModal(true)}
                                    disabled={bannerLoading}
                                    className="border-nepal-blue text-nepal-blue hover:bg-nepal-blue hover:text-white"
                                >
                                    <Edit className="mr-2 h-4 w-4" /> Update Banner
                                </Button>
                            </div>
                        </div>
                    </div>
                ) : (
                    <div className="flex flex-col items-center gap-4 py-8 text-center">
                        <div className="w-16 h-16 bg-nepal-blue/10 rounded-full flex items-center justify-center">
                            <ImageIcon className="h-8 w-8 text-nepal-blue" />
                        </div>
                        <div className="space-y-2">
                            <div className="text-gray-600 font-medium">No banner exists</div>
                            <div className="text-sm text-gray-500">Create a banner to display on your site</div>
                        </div>
                        <Button
                            variant="outline"
                            onClick={() => setShowModal(true)}
                            disabled={bannerLoading}
                            className="border-nepal-blue text-nepal-blue hover:bg-nepal-blue hover:text-white"
                        >
                            <Plus className="mr-2 h-4 w-4" /> Create Banner
                        </Button>
                    </div>
                )}

                {bannerLoading && (
                    <div className="flex items-center justify-center py-4">
                        <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-nepal-blue"></div>
                        <span className="ml-2 text-sm text-gray-600">Loading...</span>
                    </div>
                )}
            </CardContent>
            <ModalDialogWrapper
                open={showModal}
                setOpen={setShowModal}
                title={banner ? "Update Banner" : "Create Banner"}
                subTitle={banner ? "Update the banner details" : "Create a new banner"}
                className="w-[50vw] max-w-none overflow-hidden z-[101] flex flex-col p-4"
            >
                <BannerForm onClose={() => setShowModal(false)} isEdit={!!banner} bannerData={banner} />
            </ModalDialogWrapper>
        </Card>
    )
}
