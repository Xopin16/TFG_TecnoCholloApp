import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ProductListComponent } from './components/product-list/product-list.component';
import { UserListComponent } from './components/user-list/user-list.component';
import { VentaListComponent } from './components/venta-list/venta-list.component';
import { CategoryListComponent } from './components/category-list/category-list.component';
import { LoginComponent } from './components/login/login.component';
import { RegisterComponent } from './components/register/register.component';
import { ProductDetailComponent } from './components/product-detail/product-detail.component';
import { EditProductComponent } from './components/edit-product/edit-product.component';
import { NewProductComponent } from './components/new-product/new-product.component';
import { NewCategoryComponent } from './components/new-category/new-category.component';
import { EditCategoryComponent } from './components/edit-category/edit-category.component';
import { CategoryProductsComponent } from './components/category-products/category-products.component';
import { UserProfileComponent } from './components/user-profile/user-profile.component';
import { UserMeComponent } from './components/user-me/user-me.component';

const routes: Routes = [
  {
    path: 'product',
    children: [
      { path: '', component: ProductListComponent },
      { path: ':id', component: ProductDetailComponent },
    ],
  },
  {path: 'login', component: LoginComponent},
  {path: 'register', component: RegisterComponent},
  {path: 'category', component: CategoryListComponent},
  {
    path: 'user',
    children: [
      { path: '', component: UserListComponent },
      { path: ':id', component: UserProfileComponent },
    ],
  },
  {path: 'profile', component: UserMeComponent},
  {path: 'venta', component: VentaListComponent},
  {path: 'edit-product/:id', component: EditProductComponent},
  {path: 'new-product', component: NewProductComponent},
  {path: 'new-category', component: NewCategoryComponent},
  {path: 'edit-category/:id', component: EditCategoryComponent},
  {path: 'category-product/:id', component: CategoryProductsComponent},
  {path: '', redirectTo: '/login', pathMatch: 'full'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
