'use client'

import ModalDialogWrapper from '../../components/ModalDialogWrapper';
import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
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
import { Search, Edit, Users, ChevronLeft, ChevronRight, UserCheck, UserX, Crown, Download, Trash2 } from 'lucide-react'
import { RootState } from '@/lib/redux/store'
import { Member, Role } from '@/lib/types'
import MemberProfileForm from './MemberProfileForm'
import { Form, FormControl, FormField, FormItem } from '../../components/ui/form'
import { useForm } from 'react-hook-form'
import imageUrl from '@/lib/helpers/baseUrls'
import SelectFormItem from '../../components/form-items/selectFormItems'
import FormWrapper from '../../components/form-items/form-wrapper'
import InputFormItem from '../../components/form-items/input-form-item'
import { PopConfirmDeleteIconBtn } from '../../components/buttons/iconBtns'

export default function MembersContent() {
  const dispatch = useDispatch()
  const { members, isLoading, page, totalPages, createUpdateSuccess, total, downloadLoading, deleteSuccess } = useSelector((state: RootState) => state.memberReducer)
  const [showProfileForm, setShowProfileForm] = useState(false)


  // Form setup for all filters
  const form = useForm({
    defaultValues: {
      search: '',
      // isVerified: 'all' as 'all' | 'verified' | 'unverified',
      // isSubscribed: 'all' as 'all' | 'subscribed' | 'notSubscribed',
    }
  })

  const searchKeyword = form.watch('search')
  // const isVerified = form.watch('isVerified')
  // const isSubscribed = form.watch('isSubscribed')
  const dispatchObj = {
    type: 'FETCH_MEMBERS_REQUEST',
    payload: {
      page,
      // isVerified: isVerified === 'verified' ? true : isVerified === 'unverified' ? false : undefined,
      // isSubscribed: isSubscribed === 'subscribed' ? true : isSubscribed === 'notSubscribed' ? false : undefined,
      limit: 10,
      search: searchKeyword.trim() || undefined,
    }
  }
  // Combined effect for both page changes and search
  useEffect(() => {
    const searchTimeout = setTimeout(() => {
      dispatch(dispatchObj);
    }, searchKeyword ? 500 : 0); // No delay for page changes or empty search
    return () => clearTimeout(searchTimeout);
  }, [page, searchKeyword]);

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  //delete success fetch
  useEffect(() => {
    if (deleteSuccess) {
      dispatch({
        type: 'FETCH_MEMBERS_REQUEST',
      });
    }
  }, [deleteSuccess]);

  const onRefreshClick = () => {
    form.reset()
    dispatch({
      type: 'FETCH_MEMBERS_REQUEST',
      payload: {
      }
    });
  }

  useEffect(() => {
    if (createUpdateSuccess) {
      setShowProfileForm(false)
      dispatch({
        type: 'FETCH_MEMBERS_REQUEST',
        payload: {},
      })
    }
  }, [createUpdateSuccess])



  const handlePageChange = (newPage: number) => {
    dispatch({
      type: 'SET_PAGE',
      payload: {
        page: newPage
      }
    });
  }

  const handleEditMember = (member: Member) => {
    dispatch({
      type: 'SET_SELECTED_MEMBER',
      payload: member
    });
    setShowProfileForm(true);
  }

  const handleDeleteMember = (memberId: string) => {
    dispatch({
      type: 'DELETE_MEMBER_ACCOUNT_REQUEST',
      payload: memberId
    });
  }

  useEffect(() => {
    if (!showProfileForm) {
      dispatch({ type: 'CLEAR_CODE' })
    }
  }, [showProfileForm])

  const getRoleIcon = (role: Role) => {
    switch (role) {
      case Role.ADMIN:
        return <Crown className="h-4 w-4 text-yellow-600" />
      case Role.MODERATOR:
        return <UserCheck className="h-4 w-4 text-blue-600" />
      default:
        return <Users className="h-4 w-4 text-gray-600" />
    }
  }

  const getRoleBadgeColor = (role: Role) => {
    switch (role) {
      case Role.ADMIN:
        return 'bg-yellow-100 text-yellow-800'
      case Role.MODERATOR:
        return 'bg-blue-100 text-blue-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  const handleDownloadCsv = () => {
    dispatch({
      type: 'DOWNLOAD_MEMBERS_CSV_REQUEST'
    });
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold nepal-blue">Members Management</h1>
          <p className="text-gray-600">Manage community members and their profiles</p>
        </div>
        <Button
          onClick={handleDownloadCsv}
          className="bg-green-600 hover:bg-green-700 text-white"
          disabled={isLoading || downloadLoading}
        >
          <Download className="h-4 w-4 mr-2" />
          {downloadLoading ? 'Downloading...' : 'Download CSV'}
        </Button>
      </div>

      {/* Filters */}
      <Card className="border mb-2">
        <FormWrapper form={form}>
          <div className="flex flex-row flex-wrap items-end gap-4 p-4">
            <InputFormItem
              label="Search"
              name="search"
              value={form.watch('search')}
              onChange={(e) => form.setValue('search', e.target.value)}
              placeholder="Search members..."
              span={15}
              prefix={<Search size={16} className="text-gray-400" />}
            />
            {/* <SelectFormItem
              span={15}
              value={form.watch('isVerified')}
              name="isVerified"
              onChange={(value) => form.setValue('isVerified', value as 'all' | 'verified' | 'unverified')}
              label="Verification Status"
              options={[
                { value: "all", name: "All" },
                { value: "verified", name: "Verified" },
                { value: "unverified", name: "Unverified" },
              ]}
            />
            <SelectFormItem
              span={15}
              value={form.watch('isSubscribed')}
              name="isSubscribed"
              onChange={(value) => form.setValue('isSubscribed', value as 'all' | 'subscribed' | 'notSubscribed')}
              label="Subscription Status"
              options={[
                { value: "all", name: "All" },
                { value: "subscribed", name: "Subscribed" },
                { value: "notSubscribed", name: "Not Subscribed" },
              ]}
            /> */}
          </div>
        </FormWrapper>
      </Card>

      {/* Members Table */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Users className="h-5 w-5" />
            Community Members ({total || 0})
          </CardTitle>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <div className="flex justify-center items-center py-8">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-nepal-blue"></div>
            </div>
          ) : !members || members.length === 0 ? (
            <div className="text-center py-8 text-gray-500">
              <Users className="mx-auto h-12 w-12 mb-4 opacity-50" />
              <p>No members found.</p>
            </div>
          ) : (
            <>
              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Member</TableHead>
                      <TableHead>Phone</TableHead>
                      <TableHead>City</TableHead>

                      {/* <TableHead>Role</TableHead> */}
                      {/* <TableHead>Verification Status</TableHead> */}
                      {/* <TableHead>Subscription</TableHead> */}
                      <TableHead>Last Login</TableHead>
                      <TableHead className="text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {members.map((member) => (
                      <TableRow key={member._id}>
                        <TableCell>
                          <div className="flex items-center space-x-3">
                            {/* <Avatar className="h-10 w-10">
                              <AvatarImage src={imageUrl + member.photo?.path || "/placeholder.svg"} alt={member.name || 'Member'} />
                              <AvatarFallback>
                                {(member.name || 'M').split(' ').map(n => n[0]).join('').toUpperCase()}
                              </AvatarFallback>
                            </Avatar> */}
                            <div>
                              <div className="font-medium">{member.name || 'Unknown'}</div>
                              {/* <div className="text-sm text-gray-500">{member.email || 'No email'}</div> */}
                            </div>
                          </div>
                        </TableCell>
                        <TableCell>
                          <div className="text-sm">
                            {member.phone || 'No phone number'}
                          </div>
                        </TableCell>
                        <TableCell>
                          <div className="text-sm">
                            {member.city || 'No city'}
                          </div>
                        </TableCell>
                        {/* <TableCell>
                          <div className="flex items-center space-x-2">
                            {getRoleIcon(member.role)}
                            <Badge className={getRoleBadgeColor(member.role)}>
                              {member.role}
                            </Badge>
                          </div>
                        </TableCell> */}
                        {/* <TableCell>
                          <div className="flex flex-col space-y-1">
                            <Badge variant={member.isVerified ? "default" : "secondary"} className={member.isVerified ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"}>
                              {member.isVerified ? 'Verified' : 'Unverified'}
                            </Badge>
                          </div>
                        </TableCell> */}
                        {/* <TableCell>
                          {member.isSubscribed ? (
                            <div>
                              <Badge className="bg-nepal-blue/10 text-nepal-blue">
                                Subscribed
                              </Badge>
                              {member.subscriptionExpiry && (
                                <div className="text-xs text-gray-500 mt-1">
                                  Until {formatDate(member.subscriptionExpiry)}
                                </div>
                              )}
                            </div>
                          ) : (
                            <Badge variant="outline">
                              Not Subscribed
                            </Badge>
                          )}
                        </TableCell> */}
                        <TableCell>
                          <div className="text-sm">
                            {formatDate(member.lastLogin || '')}
                          </div>
                        </TableCell>
                        {/* <TableCell>
                          <div className="text-sm">
                            {member.city && member.state ? (
                              <div>
                                <div>{member.city}, {member.state}</div>
                                {member.zipCode && (
                                  <div className="text-xs text-gray-500">{member.zipCode}</div>
                                )}
                              </div>
                            ) : (
                              <span className="text-gray-400">Not provided</span>
                            )}
                          </div>
                        </TableCell> */}
                        <TableCell className="text-right">
                          <div className="flex items-center justify-end gap-2">
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => handleEditMember(member)}
                            >
                              <Edit className="h-4 w-4" />
                            </Button>
                            <PopConfirmDeleteIconBtn
                              onConfirm={() => handleDeleteMember(member._id)}
                              loading={isLoading}
                              tooltip="Delete Member Account"
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

      {/* Member Profile Edit Dialog */}
      <ModalDialogWrapper
        open={showProfileForm}
        setOpen={setShowProfileForm}
        title="Edit Member Profile"
        subTitle="Update member information and settings"
      >
        <MemberProfileForm
          onClose={() => {
            setShowProfileForm(false)
            dispatch({ type: 'CLEAR_CODE' })
          }}
        />
      </ModalDialogWrapper>
    </div>
  )
}
