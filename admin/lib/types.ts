export interface Event {
  _id: string
  title: string
  description: string
  date: string
  media: Array<{ url: string; type: string }>
  documents: string[]
  createdAt: string
  updatedAt: string
}

export interface Blog {
  _id: string
  title: string
  description: string
  uploadIds: string[]
  media: Array<{ url: string; type: string }>
  documents: string[]
  createdAt: string
  updatedAt: string
}

export interface Category {
  _id: string
  name: string
  createdAt: string
  updatedAt: string
}

export interface SubCategory {
  _id: string
  name: string
  parentId: string
  createdAt: string
  updatedAt: string
}

export interface Report {
  _id: string
  title: string
  description: string
  category: string
  subCategory: string
  uploadIds: string[]
  media: Array<{ url: string; type: string }>
  documents: string[]
  createdAt: string
  updatedAt: string
}

export interface Notification {
  _id: string
  title: string
  body: string
  createdAt: string
  updatedAt: string
}

export enum Role {
  USER = 'USER',
  ADMIN = 'ADMIN',
  MODERATOR = 'MODERATOR'
}

export interface Notifications {
  _id: string
  title: string
  body: string
  createdAt: string
  updatedAt: string
}

export interface Member {
  _id: string
  name: string
  phone?: string
  role: Role
  lastLogin?: string
  isDeleted: boolean
  deletedAt?: string
  city?: string
  createdAt: string
  updatedAt: string
}

export interface UploadedFile {
  uploadId: string
  filename: string
  size: number
  type: string
  url: string
}

export enum TeamType {
  EXECUTIVE = 'executive',
  ADVISORY = 'advisory',
  PASTEXECUTIVE = 'pastexecutive',
}
