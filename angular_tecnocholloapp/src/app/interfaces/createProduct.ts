export interface CreateProduct{
    id?: number
    nombre: string
    precio: number
    descripcion: string
    categoria?: string
    fechaPublicacion?: string
    imagen?: string
    cantidad: number
}