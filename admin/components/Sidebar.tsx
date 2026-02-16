'use client'

import { cn } from '@/lib/utils'
import { Button } from '@/components/ui/button'
import { usePathname } from 'next/navigation'
import Link from 'next/link'
import { LayoutDashboard, Calendar, FileText, BarChart3, Bell, Users, X, Images, Settings2 } from 'lucide-react'

interface SidebarProps {
  isOpen: boolean
  setIsOpen: (open: boolean) => void
}

const menuItems = [
  { id: 'dashboard', label: 'Dashboard', icon: LayoutDashboard, path: '/dashboard' },
  { id: 'events', label: 'Events', icon: Calendar, path: '/events' },
  { id: 'gallery', label: 'Gallery', icon: Images, path: '/gallery' },
  { id: 'teams', label: 'Teams', icon: Users, path: '/teams' },
  // { id: 'blogs', label: 'Blogs', icon: FileText, path: '/blogs' },
  // { id: 'reports', label: 'Reports', icon: BarChart3, path: '/reports' },
  { id: 'notifications', label: 'Notifications', icon: Bell, path: '/notifications' },
  { id: 'users', label: 'Users', icon: Users, path: '/users' },
  { id: 'extras', label: 'Extras', icon: Settings2, path: '/extras' },
]

export default function Sidebar({ isOpen, setIsOpen }: SidebarProps) {
  const pathname = usePathname()

  const isActive = (path: string) => {
    return pathname === path
  }
  return (
    <>
      {/* Mobile overlay */}
      {isOpen && (
        <div
          className="fixed inset-0 bg-black bg-opacity-50 z-40 lg:hidden"
          onClick={() => setIsOpen(false)}
        />
      )}

      {/* Sidebar */}
      <div className={cn(
        "fixed lg:static inset-y-0 left-0 z-50 w-64 bg-white shadow-lg transform transition-transform duration-200 ease-in-out lg:translate-x-0",
        isOpen ? "translate-x-0" : "-translate-x-full"
      )}>
        <div className="flex flex-col h-full">
          <div className="flex items-center justify-between p-6 border-b">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-nepal-blue to-nepal-red rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-lg">N</span>
              </div>
              <div>
                <h2 className="font-bold text-lg nepal-blue">NAFA</h2>
                <p className="text-xs text-gray-500">Admin Panel</p>
              </div>
            </div>
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setIsOpen(false)}
              className="lg:hidden"
            >
              <X className="h-4 w-4" />
            </Button>
          </div>

          {/* Navigation */}
          <nav className="flex-1 p-4">
            <ul className="space-y-2">
              {menuItems.map((item) => {
                const Icon = item.icon
                const active = isActive(item.path)
                return (
                  <li key={item.id}>
                    <Link href={item.path} prefetch={true} passHref legacyBehavior>
                      <a
                        className="block"
                        onClick={() => setIsOpen(false)}
                      >
                        <Button
                          variant={active ? "default" : "ghost"}
                          className={cn(
                            "w-full justify-start",
                            active
                              ? "bg-nepal-blue hover:bg-nepal-blue/90 text-white"
                              : "hover:bg-gray-100"
                          )}
                        >
                          <Icon className="mr-3 h-4 w-4" />
                          {item.label}
                        </Button>
                      </a>
                    </Link>
                  </li>
                )
              })}
            </ul>
          </nav>

          {/* Footer */}
          <div className="p-4 border-t">
            <div className="text-center text-xs text-gray-500">
              <p>Promoting Nepali culture</p>
              <p>since 1994</p>
              <p className="mt-2">Initiated by 2025-2026 Executive Team</p>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}
