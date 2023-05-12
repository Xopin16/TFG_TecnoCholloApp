export interface CategoryResponse {
    content: Category[]
    currentPage: number
    last: boolean
    first: boolean
    totalPages: number
    totalElements: number
  }
  
  export interface Category {
    id: number
    nombre: string
  }