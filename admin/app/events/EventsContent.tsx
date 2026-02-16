'use client'

import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { useForm } from 'react-hook-form'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
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
import { Plus, Search, Edit, Trash2, Calendar, ChevronLeft, ChevronRight, BellIcon } from 'lucide-react'
import { RootState } from '@/lib/redux/store'
import { PopConfirmDeleteIconBtn } from '../../components/buttons/iconBtns'
import { Event } from '@/lib/types'
import FormWrapper from '@/components/form-items/form-wrapper'
import InputFormItem from '@/components/form-items/input-form-item'
import SelectFormItem from '@/components/form-items/selectFormItems'
import ModalDialogWrapper from '@/components/ModalDialogWrapper'
import AddUpdateEventsForm from './AddUpdateEventsForm'


export default function EventsContent() {
  const dispatch = useDispatch()
  const { events, isLoading, page, totalPages, selectedEvent, deleteSuccess, createUpdateSuccess, total, reminderLoading, selectedReminder } = useSelector((state: RootState) => state.eventReducer)
  const [showAddForm, setShowAddForm] = useState(false)
  const [showEditForm, setShowEditForm] = useState(false)

  // Form setup for all filters
  const form = useForm({
    defaultValues: {
      search: '',
      filterStatus: 'all' as 'all' | 'upcoming' | 'past',
      date: '',
    }
  })

  const searchKeyword = form.watch('search')
  const filterStatus = form.watch('filterStatus')
  const date = form.watch('date')

  const dispatchObj = {
    type: "FETCH_EVENTS_REQUEST",
    payload: {
      ...(filterStatus !== 'all' && { isUpcoming: filterStatus === 'upcoming' ? true : false }),
      ...(searchKeyword && { search: searchKeyword }),
      ...(date && { date: date }),
    },
  };

  // Combined effect for filters, date, page changes and search
  useEffect(() => {
    const searchTimeout = setTimeout(() => {
      dispatch(dispatchObj);
    }, searchKeyword ? 500 : 0); // No delay for filters/page changes, 500ms for search
    return () => clearTimeout(searchTimeout);
  }, [filterStatus, date, page, searchKeyword]);


  const handlePageChange = (newPage: number) => {
    dispatch({
      type: 'SET_PAGE',
      payload: {
        page: newPage
      }
    });
  }

  useEffect(() => {
    if (createUpdateSuccess) {
      setShowAddForm(false)
      setShowEditForm(false)
      dispatch({
        type: 'FETCH_EVENTS_REQUEST',
        payload: {},
      })
    }
  }, [createUpdateSuccess])



  useEffect(() => {
    if (deleteSuccess) {
      dispatch({
        type: 'FETCH_EVENTS_REQUEST',
        payload: {},
      })
    }
  }, [deleteSuccess, dispatch])

  const handleDelete = (eventId: string) => {
    dispatch({ type: 'DELETE_EVENT_REQUEST', payload: eventId })
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

  const handleEdit = (event: Event) => {
    dispatch({ type: 'SET_SELECTED_EVENT', payload: event })
    setShowEditForm(true)
  }


  const handleRemind = (eventId: string) => {
    dispatch({ type: 'SET_SELECTED_REMINDER', payload: eventId })
    dispatch({ type: 'CREATE_REMINDER_REQUEST', payload: { eventId } })
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold nepal-blue">Events Management</h1>
          <p className="text-gray-600">Manage community events and activities</p>
        </div>
        <Button onClick={() => setShowAddForm(true)} className="bg-nepal-red hover:bg-nepal-red/90" disabled={isLoading}>
          <Plus className="mr-2 h-4 w-4" />
          Add Event
        </Button>
        <ModalDialogWrapper
          onCloseHandler={() => {
            setShowAddForm(false)
            setShowEditForm(false)
          }}
          open={showAddForm || showEditForm}
          setOpen={setShowAddForm || setShowEditForm}
          title={showEditForm ? 'Edit Event' : 'Create New Event'}
          subTitle='Manage your event details, media, and documents'
        >
          <AddUpdateEventsForm onClose={() => {
            setShowAddForm(false)
            setShowEditForm(false)
          }} isEdit={showEditForm} eventData={selectedEvent} />
        </ModalDialogWrapper>

      </div>
      <Card className="border mb-2">
        <FormWrapper form={form}>
          <div className="flex flex-row flex-wrap items-end gap-4 p-4">
            <InputFormItem
              label="Search"
              name="search"
              value={form.watch('search')}
              onChange={(e) => form.setValue('search', e.target.value)}
              placeholder="Search events..."
              span={5}
              prefix={<Search size={16} className="text-gray-400" />}
            />
            <SelectFormItem
              span={10}
              label="Filter Status"
              name="filterStatus"
              value={form.watch('filterStatus')}
              onChange={(value) => form.setValue('filterStatus', value as 'all' | 'upcoming' | 'past')}
              options={[
                { value: "all", name: "All" },
                { value: "upcoming", name: "Upcoming" },
                { value: "past", name: "Past" },
              ]}
            />
            <InputFormItem
              label="Date"
              name="date"
              type="date"
              value={form.watch('date')}
              onChange={(e) => form.setValue('date', e.target.value)}
              placeholder="Select date"
              span={4}
            />
            <div className="flex items-end h-full">
            </div>
          </div>
        </FormWrapper>
      </Card>
      {/* Events Table */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Calendar className="h-5 w-5" />
            Events ({total || 0})
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
                      <TableHead>Date</TableHead>
                      <TableHead>Media</TableHead>
                      <TableHead>Documents</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead className="text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {events.length === 0 ? (
                      <TableRow>
                        <TableCell colSpan={6} className="text-center text-gray-500 py-8">
                          No events found.
                        </TableCell>
                      </TableRow>
                    ) : (
                      events.map((event) => (
                        <TableRow key={event._id}>
                          <TableCell>
                            <div>

                              <div className="font-medium">{event.title}</div>
                              <div className="text-sm text-gray-500 truncate max-w-xs">
                                {event.description}
                              </div>
                            </div>
                          </TableCell>
                          <TableCell>
                            <div className="text-sm">
                              {formatDate(event.date)}
                            </div>
                          </TableCell>
                          <TableCell>
                            <Badge variant="secondary">
                              {event.media?.length || 0} files
                            </Badge>
                          </TableCell>
                          <TableCell>
                            <Badge variant="outline">
                              {event.documents?.length || 0} docs
                            </Badge>
                          </TableCell>
                          <TableCell>
                            <Badge
                              variant={new Date(event.date) > new Date() ? "default" : "secondary"}
                              className={new Date(event.date) > new Date() ? "bg-green-100 text-green-800" : ""}
                            >
                              {new Date(event.date) > new Date() ? 'Upcoming' : 'Past'}
                            </Badge>
                          </TableCell>
                          <TableCell className="text-right">
                            <div className="flex justify-end gap-2">

                              {selectedReminder === event._id && reminderLoading === true ? (
                                <div className="flex items-center justify-center">
                                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-nepal-blue"></div>
                                </div>
                              ) : (
                                <Button
                                  disabled={reminderLoading}
                                  variant="outline"
                                  size="sm"
                                  onClick={() => handleRemind(event._id)}
                                >
                                  <BellIcon className="h-4 w-4" />
                                </Button>
                              )}
                              <Button
                                variant="outline"
                                size="sm"
                                onClick={() => handleEdit(event)}
                              >
                                <Edit className="h-4 w-4" />
                              </Button>
                              <PopConfirmDeleteIconBtn
                                onConfirm={() => handleDelete(event._id)}
                              />
                            </div>
                          </TableCell>
                        </TableRow>
                      ))
                    )}
                  </TableBody>
                </Table>
              </div>

              {!isLoading && events && events.length > 0 && totalPages && totalPages > 1 && (
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
