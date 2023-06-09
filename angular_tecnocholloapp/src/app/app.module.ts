import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { DatePipe } from '@angular/common';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { UserListComponent } from './components/user-list/user-list.component';
import { ProductListComponent } from './components/product-list/product-list.component';
import { CategoryListComponent } from './components/category-list/category-list.component';
import { VentaListComponent } from './components/venta-list/venta-list.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { MaterialImportModule } from './material-imports/material-imports.module';
import { LoginComponent } from './components/login/login.component';
import { RegisterComponent } from './components/register/register.component';
import { ProductDetailComponent } from './components/product-detail/product-detail.component';
import { CategoryProductsComponent } from './components/category-products/category-products.component';
import { UserProfileComponent } from './components/user-profile/user-profile.component';
import { UserMeComponent } from './components/user-me/user-me.component';
import { ChangePasswordDialogComponent } from './components/change-password-dialog/change-password-dialog.component';
import { DeleteAccountDialogComponent } from './components/delete-account-dialog/delete-account-dialog.component';
import { CreateProductDialogComponent } from './components/create-product-dialog/create-product-dialog.component';
import { EditProductDialogComponent } from './components/edit-product-dialog/edit-product-dialog.component';
import { CreateCategoryDialogComponent } from './components/create-category-dialog/create-category-dialog.component';
import { EditCategoryDialogComponent } from './components/edit-category-dialog/edit-category-dialog.component';
import { DeleteCategoryDialogComponent } from './components/delete-category-dialog/delete-category-dialog.component';
import { DeleteProductDialogComponent } from './components/delete-product-dialog/delete-product-dialog.component';
import { DeleteUserDialogComponent } from './components/delete-user-dialog/delete-user-dialog.component';
import { MenuComponent } from './components/menu/menu.component';
import { MainContentComponent } from './components/main-content/main-content.component';
import { AuthGuard } from './_helpers/auth.guard';

@NgModule({
  declarations: [
    AppComponent,
    UserListComponent,
    ProductListComponent,
    CategoryListComponent,
    VentaListComponent,
    LoginComponent,
    RegisterComponent,
    ProductDetailComponent,
    CategoryProductsComponent,
    UserProfileComponent,
    UserMeComponent,
    ChangePasswordDialogComponent,
    DeleteAccountDialogComponent,
    CreateProductDialogComponent,
    EditProductDialogComponent,
    CreateCategoryDialogComponent,
    EditCategoryDialogComponent,
    DeleteCategoryDialogComponent,
    DeleteProductDialogComponent,
    DeleteUserDialogComponent,
    MenuComponent,
    MainContentComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    FormsModule,
    HttpClientModule,
    MaterialImportModule,
    ReactiveFormsModule
  ],
  providers: [AuthGuard],
  bootstrap: [AppComponent]
})
export class AppModule { }
