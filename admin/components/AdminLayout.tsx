'use client'

import { useState } from 'react'
import { useDispatch } from 'react-redux'
import { usePathname } from 'next/navigation'
import { Button } from '@/components/ui/button'
import Sidebar from './Sidebar'
import { LogOut, Menu } from 'lucide-react'

interface AdminLayoutProps {
    children: React.ReactNode
}

export default function AdminLayout({ children }: AdminLayoutProps) {
    const [sidebarOpen, setSidebarOpen] = useState(true)
    const dispatch = useDispatch()
    const pathname = usePathname()

    const handleLogout = () => {
        dispatch({ type: 'ADMIN_LOGOUT' })
    }

    // // Extract section name from pathname
    // const getSectionName = () => {
    //     const segments = pathname.split('/')
    //     const section = segments[segments.length - 1]
    //     return section.charAt(0).toUpperCase() + section.slice(1)
    // }

    return (
        <div className="flex h-screen bg-gray-50">
            <Sidebar
                isOpen={sidebarOpen}
                setIsOpen={setSidebarOpen}
            />

            <div className="flex-1 flex flex-col overflow-hidden">
                {/* Header */}
                <header className="bg-white shadow-sm border-b px-6 py-4">
                    <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-4">
                            <Button
                                variant="ghost"
                                size="sm"
                                onClick={() => setSidebarOpen(!sidebarOpen)}
                                className="lg:hidden"
                            >
                                <Menu className="h-5 w-5" />
                            </Button>
                            {/* <h1 className="text-xl font-semibold nepal-blue">
                                {getSectionName()}
                            </h1> */}
                        </div>
                        <Button
                            variant="outline"
                            size="sm"
                            onClick={handleLogout}
                            className="flex items-center space-x-2"
                        >
                            <LogOut className="h-4 w-4" />
                            <span>Logout</span>
                        </Button>
                    </div>
                </header>

                {/* Main Content */}
                <main className="flex-1 overflow-auto p-6">
                    {children}
                </main>
            </div>
        </div>
    )
}
