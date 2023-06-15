import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ProductListComponent } from './components/product-list/product-list.component';
import { UserListComponent } from './components/user-list/user-list.component';
import { VentaListComponent } from './components/venta-list/venta-list.component';
import { CategoryListComponent } from './components/category-list/category-list.component';
import { LoginComponent } from './components/login/login.component';
import { RegisterComponent } from './components/register/register.component';
import { ProductDetailComponent } from './components/product-detail/product-detail.component';
import { CategoryProductsComponent } from './components/category-products/category-products.component';
import { UserProfileComponent } from './components/user-profile/user-profile.component';
import { UserMeComponent } from './components/user-me/user-me.component';
import { MenuComponent } from './components/menu/menu.component';
import { MainContentComponent } from './components/main-content/main-content.component';
import { AuthGuard } from './_helpers/auth.guard';

const routes: Routes = [
  { path: 'login', component: LoginComponent },
  {
    path: '',
    canActivate: [AuthGuard],
    component: MainContentComponent,
    children: [
      {
        path: 'product',
        children: [
          { path: '', component: ProductListComponent },
          { path: ':id', component: ProductDetailComponent },
        ],
      },
      { path: 'register', component: RegisterComponent },
      { path: 'category', component: CategoryListComponent },
      {
        path: 'user',
        children: [
          { path: '', component: UserListComponent },
          { path: ':id', component: UserProfileComponent },
        ],
      },
      { path: 'profile', component: UserMeComponent },
      { path: 'venta', component: VentaListComponent },
      { path: 'category-product/:id', component: CategoryProductsComponent },
    ],
  },
  { path: '**', redirectTo: '/login' },
];


@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
