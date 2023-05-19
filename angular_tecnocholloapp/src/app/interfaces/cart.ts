import { User } from "./user"
import { LineaVenta } from "./venta"

export interface Cart {

    id: number
    lineasDeVenta: LineaVenta[]
    user: User

}
