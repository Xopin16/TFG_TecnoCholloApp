export interface UserResponse {
  user: User[]
  currentPage: number
  last: boolean
  first: boolean
  totalPages: number
  totalElements: number
}

export interface User {
  id: string
  username: string
  avatar: string
  fullName: string
  role: string
  email: string
  createdAt: string
}