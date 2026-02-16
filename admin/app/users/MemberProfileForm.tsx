'use client'

import { useState, useEffect, use } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { RootState } from '@/lib/redux/store'
import imageUrl from '@/lib/helpers/baseUrls'

export default function MemberProfileForm({ onClose }: { onClose: () => void }) {
  const dispatch = useDispatch()
  const { selectedMember, isLoading, codeLoading, code } = useSelector((state: RootState) => state.memberReducer)
  const [formData, setFormData] = useState({
    name: '',
    // email: '',
    phone: '',
    // role: Role.USER,
    // userCode: '',
    // isActive: true,
    // isVerified: false,
    // isSubscribed: false,
    // subscriptionExpiry: '',
    // addressLine1: '',
    // addressLine2: '',
    city: '',
    // state: '',
    // zipCode: '',
    // country: '',
  })

  useEffect(() => {
    if (selectedMember) {
      setFormData({
        name: selectedMember.name || '',
        // email: selectedMember.email || '',
        phone: selectedMember.phone || '',
        // role: selectedMember.role || Role.USER,
        // userCode: selectedMember.userCode || '',
        // isActive: selectedMember.isActive ?? true,
        // isVerified: selectedMember.isVerified ?? false,
        // isSubscribed: selectedMember.isSubscribed ?? false,
        // subscriptionExpiry: selectedMember.subscriptionExpiry ? selectedMember.subscriptionExpiry.split('T')[0] : '',
        // addressLine1: selectedMember.addressLine1 || '',
        // addressLine2: selectedMember.addressLine2 || '',
        city: selectedMember.city || '',
        // state: selectedMember.state || '',
        // zipCode: selectedMember.zipCode || '',
        // country: selectedMember.country || '',
      })
    }
  }, [selectedMember])

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  const handleSwitchChange = (field: string, value: boolean) => {
    setFormData({
      ...formData,
      [field]: value
    })
  }

  useEffect(() => {
    if (!codeLoading && code) {
      setFormData(prev => ({
        ...prev,
        userCode: code
      }))
    }
  }, [code, codeLoading])

  // const handleRoleChange = (value: string) => {
  //   setFormData({
  //     ...formData,
  //     // role: value as Role
  //   })
  // }

  const handleCodeGeneration = () => {
    dispatch({
      type: 'GENERATE_MEMBER_CODE_REQUEST',
    })
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()

    if (selectedMember) {
      const updateData = {
        _id: selectedMember._id,
        ...formData,
        // subscriptionExpiry: formData.subscriptionExpiry ? new Date(formData.subscriptionExpiry).toISOString() : undefined
      }

      dispatch({
        type: 'UPDATE_MEMBER_REQUEST',
        payload: updateData
      })
      onClose()
    }
  }

  if (!selectedMember) return null

  const memberName = selectedMember.name || 'Unknown Member'
  const memberCreatedAt = selectedMember.createdAt || new Date().toISOString()

  // Safe avatar fallback generation
  const getAvatarFallback = (name: string) => {
    if (!name || name.trim() === '') return 'M'
    return name.split(' ').map(n => n[0]).join('').toUpperCase().substring(0, 2)
  }

  return (
    <div className="flex flex-col h-full">
      <div className="flex-1 overflow-y-auto px-6 pb-6">
        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Profile Header */}
          <div className="flex items-center space-x-4 p-4 bg-gray-50 rounded-lg">
            <Avatar className="h-16 w-16">
              <AvatarFallback className="text-lg">
                {getAvatarFallback(memberName)}
              </AvatarFallback>
            </Avatar>
            <div>
              <h3 className="text-lg font-semibold">{memberName}</h3>
              {/* <p className="text-gray-600">{memberEmail}</p> */}
              {/* <p className="text-sm text-gray-500">
                Member since {new Date(memberCreatedAt).toLocaleDateString()}
              </p> */}
            </div>
          </div>

          {/* Basic Information */}
          <Card>
            <CardHeader>
              <CardTitle>Basic Information</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="name">Full Name</Label>
                  <Input
                    id="name"
                    name="name"
                    value={formData.name}
                    onChange={handleInputChange}
                    required
                  />
                </div>
                <div>
                  <Label htmlFor="phone">Phone</Label>
                  <Input
                    id="phone"
                    name="phone"
                    value={formData.phone}
                    onChange={handleInputChange}
                  />
                </div>
                {/* <div>
                  <Label htmlFor="userCode">User Code</Label>
                  <Input
                    id="userCode"
                    name="userCode"
                    value={formData.userCode}
                    onChange={handleInputChange}
                  />
                  <Button
                    className="mt-2"
                    onClick={handleCodeGeneration}
                    disabled={codeLoading}
                  >
                    {codeLoading ? 'Generating...' : 'Generate Code'}
                  </Button>
                </div> */}
              </div>
            </CardContent>
          </Card>

          {/* Role and Status */}
          {/* <Card>
            <CardHeader>
              <CardTitle>Role and Status</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="role">Role</Label>
                  <Select value={formData.role} onValueChange={handleRoleChange}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value={Role.USER}>User</SelectItem>
                      <SelectItem value={Role.MODERATOR}>Moderator</SelectItem>
                      <SelectItem value={Role.ADMIN}>Admin</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div>
                  <Label htmlFor="subscriptionExpiry">Subscription Expiry</Label>
                  <Input
                    id="subscriptionExpiry"
                    name="subscriptionExpiry"
                    type="date"
                    value={formData.subscriptionExpiry}
                    onChange={handleInputChange}
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="flex items-center space-x-2">
                  <Switch
                    id="isActive"
                    checked={formData.isActive}
                    onCheckedChange={(value) => handleSwitchChange('isActive', value)}
                  />
                  <Label htmlFor="isActive">Active</Label>
                </div>
                <div className="flex items-center space-x-2">
                  <Switch
                    id="isVerified"
                    checked={formData.isVerified}
                    onCheckedChange={(value) => handleSwitchChange('isVerified', value)}
                  />
                  <Label htmlFor="isVerified">Verified</Label>
                </div>
                <div className="flex items-center space-x-2">
                  <Switch
                    id="isSubscribed"
                    checked={formData.isSubscribed}
                    onCheckedChange={(value) => handleSwitchChange('isSubscribed', value)}
                  />
                  <Label htmlFor="isSubscribed">Subscribed</Label>
                </div>
              </div>
            </CardContent>
          </Card> */}

          {/* Address Information */}
          <Card>
            <CardHeader>
              <CardTitle>Address Information</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              {/* <div>
                <Label htmlFor="addressLine1">Address Line 1</Label>
                <Input
                  id="addressLine1"
                  name="addressLine1"
                  value={formData.addressLine1}
                  onChange={handleInputChange}
                />
              </div>
              <div>
                <Label htmlFor="addressLine2">Address Line 2</Label>
                <Input
                  id="addressLine2"
                  name="addressLine2"
                  value={formData.addressLine2}
                  onChange={handleInputChange}
                />
              </div> */}
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <div>
                  <Label htmlFor="city">City</Label>
                  <Input
                    id="city"
                    name="city"
                    value={formData.city}
                    onChange={handleInputChange}
                  />
                </div>
                {/* <div>
                  <Label htmlFor="state">State</Label>
                  <Input
                    id="state"
                    name="state"
                    value={formData.state}
                    onChange={handleInputChange}
                  />
                </div>
                <div>
                  <Label htmlFor="zipCode">ZIP Code</Label>
                  <Input
                    id="zipCode"
                    name="zipCode"
                    value={formData.zipCode}
                    onChange={handleInputChange}
                  />
                </div> */}
                {/* <div>
                  <Label htmlFor="country">Country</Label>
                  <Input
                    id="country"
                    name="country"
                    value={formData.country}
                    onChange={handleInputChange}
                  />
                </div> */}
              </div>
            </CardContent>
          </Card>
        </form>
      </div>

      {/* Form Actions - Sticky at bottom */}
      <div className="shrink-0 border-t bg-white p-6">
        <div className="flex justify-end space-x-4">
          <Button type="button" variant="outline" onClick={onClose}>
            Cancel
          </Button>
          <Button
            onClick={handleSubmit}
            className="bg-nepal-blue hover:bg-nepal-blue/90"
            disabled={isLoading}
          >
            {isLoading ? 'Updating...' : 'Update Profile'}
          </Button>
        </div>
      </div>
    </div>
  )
}
