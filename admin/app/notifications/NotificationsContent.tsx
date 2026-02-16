'use client'

import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
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
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'
import { Plus, Search, Bell, ChevronLeft, ChevronRight, Send, Edit } from 'lucide-react'
import { RootState } from '@/lib/redux/store'
import { useForm } from 'react-hook-form'
import FormWrapper from '../../components/form-items/form-wrapper'
import InputFormItem from '../../components/form-items/input-form-item'
import { PopConfirmDeleteIconBtn } from '../../components/buttons/iconBtns'


export default function NotificationsContent() {
  const dispatch = useDispatch()
  const { notifications, isLoading, createSuccess, deleteSuccess, page, totalPages } = useSelector((state: RootState) => state.notificationReducer)
  const [showSendForm, setShowSendForm] = useState(false)
  const [formData, setFormData] = useState({
    title: '',
    body: '',
    data: ''
  })
  const form = useForm({
    defaultValues: {
      search: '',
    }
  })


  const searchKeyword = form.watch('search')
  const dispatchObj = {
    type: 'FETCH_NOTIFICATIONS_REQUEST',
    payload: {
      page,
      limit: 10,
      search: searchKeyword.trim() || undefined,
    }
  }

  useEffect(() => {
    if (createSuccess || deleteSuccess) {
      dispatch({
        type: 'FETCH_NOTIFICATIONS_REQUEST',
        payload: {},
      })
    }
  }, [createSuccess, deleteSuccess])


  const handlePageChange = (newPage: number) => {
    dispatch({
      type: 'SET_PAGE',
      payload: {
        page: newPage
      }
    });
  }

  useEffect(() => {
    const searchTimeout = setTimeout(() => {
      dispatch(dispatchObj);
    }, searchKeyword ? 500 : 0); // No delay for page changes or empty search
    return () => clearTimeout(searchTimeout);
  }, [page, searchKeyword]);



  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    //validate title and body
    if (!formData.title.trim()) {
      alert('Please enter a notification title');
      return;
    }

    if (!formData.body.trim()) {
      alert('Please enter a notification message');
      return;
    }
    const createPayload = {
      title: formData.title,
      body: formData.body,
    }
    dispatch({
      type: 'CREATE_NOTIFICATIONS_REQUEST',
      payload: createPayload
    })
    setFormData({ title: '', body: '', data: '' })
    setShowSendForm(false)
  }
  const handleDelete = (eventId: string) => {
    // This function will be called after the user confirms deletion in the PopConfirmDeleteIconBtn
    console.log('Deleting event:', eventId)
    dispatch({ type: 'DELETE_NOTIFICATIONS_REQUEST', payload: eventId })
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold nepal-blue">Notifications</h1>
          <p className="text-gray-600">Send push notifications to community members</p>
        </div>
        <Dialog open={showSendForm} onOpenChange={setShowSendForm}>
          <DialogTrigger asChild>
            <Button className="bg-nepal-red hover:bg-nepal-red/90" disabled={isLoading}>
              <Send className="mr-2 h-4 w-4" />
              Send Notification
            </Button>
          </DialogTrigger>
          <DialogContent className="max-w-2xl">
            <DialogHeader>
              <DialogTitle>Send Push Notification</DialogTitle>
              <DialogDescription>
                Send a notification to all active community members
              </DialogDescription>
            </DialogHeader>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <Label htmlFor="title">Notification Title</Label>
                <Input
                  id="title"
                  name="title"
                  value={formData.title}
                  onChange={handleInputChange}
                  placeholder="Enter notification title"
                  required
                />
              </div>
              <div>
                <Label htmlFor="body">Message Body</Label>
                <Textarea
                  id="body"
                  name="body"
                  value={formData.body}
                  onChange={handleInputChange}
                  placeholder="Enter notification message"
                  rows={8}
                  required
                />
              </div>
              {/* <div>
                <Label htmlFor="data">Additional Data</Label>
                <Textarea
                  id="data"
                  name="data"
                  value={formData.data}
                  onChange={handleInputChange}
                  placeholder="Enter any additional data"
                  rows={4}
                />
              </div> */}
              <div className="flex justify-end space-x-4">
                <Button type="button" variant="outline" onClick={() => setShowSendForm(false)}>
                  Cancel
                </Button>
                <Button type="submit" className="bg-nepal-blue hover:bg-nepal-blue/90" disabled={isLoading}>
                  <Send className="mr-2 h-4 w-4" />
                  Send Notification
                </Button>
              </div>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <Card className="border mb-2">
        <FormWrapper form={form}>
          <div className="flex flex-row flex-wrap items-end gap-4 p-4">
            <InputFormItem
              label="Search"
              name="search"
              value={form.watch('search')}
              onChange={(e) => form.setValue('search', e.target.value)}
              placeholder="Search notifcations..."
              span={15}
              prefix={<Search size={16} className="text-gray-400" />}
            />

          </div>
        </FormWrapper>
      </Card>

      {/* Notifications Table */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Bell className="h-5 w-5" />
            {/* Sent Notifications ({notifications.length}) */}
          </CardTitle>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <div className="flex justify-center items-center py-8">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-nepal-blue"></div>
            </div>
          ) : !isLoading && notifications.length === 0 ? (
            <div className="text-center py-8 text-gray-500">
              <Bell className="mx-auto h-12 w-12 mb-4 opacity-50" />
              <p>No notifications sent yet.</p>
            </div>
          ) : (
            <>
              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Title</TableHead>
                      <TableHead>Message</TableHead>
                      <TableHead>Sent Date</TableHead>
                      <TableHead className="text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {notifications.map((notification) => (
                      <TableRow key={notification._id}>
                        <TableCell>
                          <div className="font-medium">{notification.title}</div>
                        </TableCell>
                        <TableCell>
                          <div className="text-sm text-gray-600 max-w-md truncate">
                            {notification.body}
                          </div>
                        </TableCell>
                        <TableCell>
                          <div className="text-sm">
                            {formatDate(notification.createdAt)}
                          </div>
                        </TableCell>
                        <TableCell className="text-right">
                          <div className="flex justify-end gap-2">
                            <PopConfirmDeleteIconBtn
                              onConfirm={() => handleDelete(notification._id)}
                            />
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>

              {/* Pagination */}
              {totalPages && totalPages > 1 && (
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
