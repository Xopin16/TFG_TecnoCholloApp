import { Product } from "./product"
import { User } from "./user"

export interface Venta {
    id: number
    lineasVenta: LineaVenta[]
    precio: number
    usuario: string
  }
  
  export interface LineaVenta{
    id: number
    cantidad: number
    producto: Product
  }
  
