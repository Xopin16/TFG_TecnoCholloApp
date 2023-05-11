import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ProductListComponent } from './components/product-list/product-list.component';
import { CartComponent } from './components/cart/cart.component';
import { UserListComponent } from './components/user-list/user-list.component';
import { VentaListComponent } from './components/venta-list/venta-list.component';

const routes: Routes = [
  {path: 'product', component: ProductListComponent},
  {path: 'cart', component: CartComponent},
  {path: 'user', component: UserListComponent},
  {path: 'venta', component: VentaListComponent},
  {path: '', redirectTo: '/product', pathMatch: 'full'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
