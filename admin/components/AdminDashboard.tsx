// 'use client'

// import { useState } from 'react'
// import { useDispatch } from 'react-redux'
// import { Button } from '@/components/ui/button'
// import Sidebar from './Sidebar'
// // import DashboardContent from './DashboardContent'
// // import BlogsContent from './BlogsContent'
// // import ReportsContent from './ReportsContent'
// // import NotificationsContent from './NotificationsContent'
// import { LogOut, Menu } from 'lucide-react'
// import EventsContent from './EventsContent'
// import MembersContent from './MembersContent'

// export default function AdminDashboard() {
//   const [activeSection, setActiveSection] = useState('dashboard')
//   const [sidebarOpen, setSidebarOpen] = useState(true)
//   const dispatch = useDispatch()

//   const handleLogout = () => {
//     dispatch({ type: 'ADMIN_LOGOUT' })
//   }

//   const renderContent = () => {
//     switch (activeSection) {
//       // case 'dashboard':
//       //   return <DashboardContent />
//       case 'events':
//         return <EventsContent />
//       // case 'blogs':
//       //   return <BlogsContent />
//       // case 'reports':
//       //   return <ReportsContent />
//       // case 'notifications':
//       //   return <NotificationsContent />
//       case 'members':
//         return <MembersContent />
//       // default:
//       //   return <DashboardContent />
//     }
//   }

//   return (
//     <div className="flex h-screen bg-gray-50">
//       <Sidebar
//         isOpen={sidebarOpen}
//         setIsOpen={setSidebarOpen}
//       />

//       <div className="flex-1 flex flex-col overflow-hidden">
//         {/* Header */}
//         <header className="bg-white shadow-sm border-b px-6 py-4">
//           <div className="flex items-center justify-between">
//             <div className="flex items-center space-x-4">
//               <Button
//                 variant="ghost"
//                 size="sm"
//                 onClick={() => setSidebarOpen(!sidebarOpen)}
//                 className="lg:hidden"
//               >
//                 <Menu className="h-5 w-5" />
//               </Button>
//               <h1 className="text-xl font-semibold nepal-blue">
//                 {activeSection.charAt(0).toUpperCase() + activeSection.slice(1)}
//               </h1>
//             </div>
//             <Button
//               variant="outline"
//               size="sm"
//               onClick={handleLogout}
//               className="flex items-center space-x-2"
//             >
//               <LogOut className="h-4 w-4" />
//               <span>Logout</span>
//             </Button>
//           </div>
//         </header>

//         {/* Main Content */}
//         <main className="flex-1 overflow-auto p-6">
//           {renderContent()}
//         </main>
//       </div>
//     </div>
//   )
// }
