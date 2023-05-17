export interface ProductResponse {
    content: Product[]
    currentPage: number
    last: boolean
    first: boolean
    totalPages: number
    totalElements: number
  }
  
  export interface Product {
    id?: number
    nombre: string
    precio: number
    descripcion: string
    imagen?: string
    // fechaPublicacion?: string
    categoria?: string
    usuario?: string
    idCategory?: number
  }