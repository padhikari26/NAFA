'use client'

import { useEffect, useState } from 'react'
import { useSelector, useDispatch } from 'react-redux'
import { useRouter, usePathname } from 'next/navigation'
import { getLocalStorage } from '@/lib/helpers/frontendHelpers'
import LoginPage from '@/components/LoginPage'
import { API } from '@/lib/helpers/baseUrls'
import { openNotificationWithIcon } from '@/lib/helpers/notification'
import AdminLayout from './AdminLayout'

// Pages that don't require authentication
const publicPages = ['/']

export default function AuthWrapper({ children }: { children: React.ReactNode }) {
    const [isHydrated, setIsHydrated] = useState(false)
    const [serverError, setServerError] = useState(false)
    const dispatch = useDispatch()
    const { isLoggedIn } = useSelector((state: any) => state.authReducer)
    const router = useRouter()
    const pathname = usePathname()

    // Hydrate auth state from localStorage
    useEffect(() => {
        const token = getLocalStorage('token')
        if (token) {
            dispatch({ type: 'HYDRATE_AUTH', payload: { token } })
        } else {
            dispatch({ type: 'ADMIN_LOGOUT' })
        }
        setIsHydrated(true)
    }, [dispatch])

    // Set up API interceptors
    useEffect(() => {
        API.interceptors.request.use(
            async (config) => {
                const token = getLocalStorage("token")
                if (token) config.headers.set("Authorization", `Bearer ${token}`)
                return config
            },
            (error) => Promise.reject(error)
        )

        API.interceptors.response.use(
            (response) => response,
            (error) => {
                if (error?.response?.status === 401) dispatch({ type: "ADMIN_LOGOUT" })
                if (error?.response?.status === 500) setServerError(true)
                return Promise.reject(error)
            }
        )
    }, [dispatch])

    // Show server error notifications
    useEffect(() => {
        if (serverError) {
            openNotificationWithIcon(
                "info",
                "Something went wrong with the server. Please try again."
            )
            setTimeout(() => setServerError(false), 3000)
        }
    }, [serverError])

    // Handle routing based on auth state
    useEffect(() => {
        if (!isHydrated) return
        const isPublicPage = publicPages.includes(pathname)

        if (isLoggedIn) {
            if (isPublicPage) router.replace('/dashboard')
        } else {
            if (!isPublicPage) router.replace('/')
        }
    }, [isHydrated, isLoggedIn, pathname, router])

    // Show loader while auth state is being hydrated or Redux hasn't set isLoggedIn yet
    if (!isHydrated || typeof isLoggedIn === 'undefined') {
        return (
            <div className="flex items-center justify-center min-h-screen">
                <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-gray-900"></div>
            </div>
        )
    }

    // Show login page for public routes when not logged in
    if (!isLoggedIn && publicPages.includes(pathname)) {
        return <LoginPage />
    }

    // Show admin layout for authenticated routes
    if (isLoggedIn && !publicPages.includes(pathname)) {
        return <AdminLayout>{children}</AdminLayout>
    }

    // Fallback: render children directly
    return <>{children}</>
}
