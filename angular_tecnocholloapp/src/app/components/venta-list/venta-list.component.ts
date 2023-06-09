import { Component, OnInit } from '@angular/core';
import { LineaVenta, Venta } from 'src/app/interfaces/venta';
import { TokenStorageService } from 'src/app/services/token-storage.service';
import { VentaService } from 'src/app/services/venta.service';

@Component({
  selector: 'app-venta-list',
  templateUrl: './venta-list.component.html',
  styleUrls: ['./venta-list.component.css']
})
export class VentaListComponent implements OnInit {

  isLoggedIn = false;
  username?: string;
  historicoVentas: Venta[] =  [];

  constructor(private tokenStorageService: TokenStorageService, private ventaService: VentaService) { }

  ngOnInit(): void {
    this.isLoggedIn = !!this.tokenStorageService.getToken();
    if(this.isLoggedIn){
      const user = this.tokenStorageService.getUser();
      this.username = user.username;
    }
    this.getHistorico();
  }

  getHistorico(): void{
    this.ventaService.getHistorico().subscribe((resp) => {
      this.historicoVentas = resp;
    })
  }

  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }


  calcularPrecioFinal(lineasVenta: any[]): number {
    let precioFinal = 0;

    for (const lineaVenta of lineasVenta) {
      const precioLinea = lineaVenta.producto.precio * lineaVenta.cantidad;
      precioFinal += precioLinea;
    }

    return precioFinal;
  }


}
