import { Product } from "./product"
import { User } from "./user"

export interface Venta {
    id: number
    lineasDeVenta: LineaVenta[]
    precioFinal: number
    User: User[]
  }
  
  export interface LineaVenta{
    id: number
    cantidad: number
    product: Product[]
  }
  
