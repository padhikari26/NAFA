'use client'

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Users, Calendar, FileText, Bell } from 'lucide-react'

const stats = [
  {
    title: 'Members',
    value: '1,234',
    description: 'Active community members',
    icon: Users,
    color: 'nepal-blue'
  },
  {
    title: 'Events',
    value: '45',
    description: 'Events this year',
    icon: Calendar,
    color: 'nepal-red'
  },
  {
    title: 'Blog Posts',
    value: '128',
    description: 'Published articles',
    icon: FileText,
    color: 'nepal-blue'
  },
  {
    title: 'Notifications',
    value: '12',
    description: 'Pending notifications',
    icon: Bell,
    color: 'nepal-red'
  }
]

export default function DashboardContent() {
  return (
    <div className="space-y-6">
      {/* Welcome Section */}
      <div className="bg-gradient-to-r nepal-blue rounded-lg p-6 md:p-8 shadow-lg flex flex-col items-start">
        <h1 className="text-2xl md:text-3xl lg:text-4xl font-bold mb-2 drop-shadow">
          Welcome to NAFA
        </h1>
        <h2 className="text-lg md:text-xl lg:text-2xl mb-2 font-semibold drop-shadow">
          Nepalis And Friends Association, Arizona
        </h2>
        <p className="nepal-blue text-base md:text-lg">
          Promoting Nepali culture since 1994
        </p>
      </div>

      {/* <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => {
          const Icon = stat.icon
          return (
            <Card key={index} className="hover:shadow-lg transition-shadow">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-gray-600">
                  {stat.title}
                </CardTitle>
                <Icon className={`h-4 w-4 ${stat.color === 'nepal-blue' ? 'nepal-blue' : 'nepal-red'}`} />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stat.value}</div>
                <p className="text-xs text-gray-500 mt-1">
                  {stat.description}
                </p>
              </CardContent>
            </Card>
          )
        })}
      </div> */}

      {/* <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Recent Events</CardTitle>
            <CardDescription>Latest community events</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div className="flex items-center space-x-4">
                <div className="w-2 h-2 bg-nepal-red rounded-full"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium">Dashain Festival 2024</p>
                  <p className="text-xs text-gray-500">Oct 15, 2024</p>
                </div>
              </div>
              <div className="flex items-center space-x-4">
                <div className="w-2 h-2 bg-nepal-blue rounded-full"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium">Tihar Celebration</p>
                  <p className="text-xs text-gray-500">Nov 2, 2024</p>
                </div>
              </div>
              <div className="flex items-center space-x-4">
                <div className="w-2 h-2 bg-nepal-red rounded-full"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium">Cultural Workshop</p>
                  <p className="text-xs text-gray-500">Nov 15, 2024</p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card> */}

      {/* <Card>
        <CardHeader>
          <CardTitle>System Status</CardTitle>
          <CardDescription>Current system health</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <span className="text-sm">Website</span>
              <span className="text-xs bg-green-100 text-green-800 px-2 py-1 rounded-full">Online</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm">Database</span>
              <span className="text-xs bg-green-100 text-green-800 px-2 py-1 rounded-full">Connected</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm">Email Service</span>
              <span className="text-xs bg-green-100 text-green-800 px-2 py-1 rounded-full">Active</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm">Backup</span>
              <span className="text-xs bg-yellow-100 text-yellow-800 px-2 py-1 rounded-full">Scheduled</span>
            </div>
          </div>
        </CardContent>
      </Card> */}
    </div>
  )
}
