import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { Category } from 'src/app/interfaces/category';
import { Product } from 'src/app/interfaces/product';
import { CategoryService } from 'src/app/services/category.service';
import { ProductService } from 'src/app/services/product.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';
import { CreateCategoryDialogComponent } from '../create-category-dialog/create-category-dialog.component';
import { CreateProductDialogComponent } from '../create-product-dialog/create-product-dialog.component';
import { EditProductDialogComponent } from '../edit-product-dialog/edit-product-dialog.component';
import { DeleteProductDialogComponent } from '../delete-product-dialog/delete-product-dialog.component';

@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.css']
})
export class ProductListComponent implements OnInit {
  
  products: Product[] = [];
  categories: Category[] = [];
  idCategoria: number = 0;
  // newProduct: Product = {nombre: '', precio: 0, descripcion: '', cantidad: 0, categoria: ''};
  displayedColumns: string[] = ['imagen', 'nombre', 'precio', 'descripcion', 'acciones'];
  isLoggedIn = false;
  username?: string; 
  numPages = 0;
  currentPage = 0;
  searchForm!: FormGroup;

  constructor(private productService: ProductService, private tokenStorageService: TokenStorageService, 
    private router: Router, private categoryService: CategoryService, private dialog: MatDialog) { }

  ngOnInit(): void {
    // this.isLoggedIn = !!this.tokenStorageService.getToken();
    // if(this.isLoggedIn){
    //   const user = this.tokenStorageService.getUser();
    //   this.username = user.username;
    // }
    this.categoryService.getCategories(0).subscribe((resp) => {
      this.categories = resp.content;
      console.log(resp)
    });
    this.searchForm = new FormGroup({
      searchTerm: new FormControl()
    });
    
    this.getProducts(0);
  }

  getPage(page: number) {
    if (page >= 0 && page < this.numPages ) {
      this.productService.getProducts(page).subscribe(resp => {
        this.products = resp.content;
        this.numPages = resp.totalPages;
        this.currentPage = page;
      });
    }
  }

  getProducts(page: number, nombre?: string): void{
    this.productService.getProducts(page, nombre).subscribe((resp) => {
      this.products = resp.content;
      this.numPages = resp.totalPages;
      this.currentPage = page;
      console.log(resp)
    });
  }

  logout(): void {
    this.tokenStorageService.signOut();
  }

  searchProducts() {
    const searchTerm = this.searchForm.value.searchTerm;
    this.getProducts(0, searchTerm);
  }

  openCreateProductDialog(): void {
    const dialogRef = this.dialog.open(CreateProductDialogComponent, {
      width: '400px',
    });
  
    dialogRef.afterClosed().subscribe((result: any) => {
      console.log(result)
      const newProduct = result.body;
      const file = result.file;
      console.log(newProduct)
      console.log(file)
      if (result) {
        this.productService.postProduct(newProduct, file).subscribe((resp) => {
          console.log(resp)
        });
      }
    });
  }

  openEditProductDialog(id: number): void {
    this.productService.getProductId(id).subscribe((product: Product) => {
      const dialogRef = this.dialog.open(EditProductDialogComponent, {
        width: '300px',
        data: product
      });
  
      dialogRef.afterClosed().subscribe(result => {
        if (result) {
          const updateProduct = result.body;
          const file = result.file;
          this.productService.putProduct(updateProduct, id, file).subscribe(() => {
            window.location.reload()
          });
        }
      });
    });
  }
  

  openDeleteProductDialog(id: number): void{
    const dialogRef = this.dialog.open(DeleteProductDialogComponent, {
      width:'250px',
      data: { id: id }
    });

    dialogRef.afterClosed().subscribe(result => {
      if(result){
        this.deleteProduct(result);
      }
    })
  }
  

  deleteProduct(id: number){
    this.productService.deleteProduct(id).subscribe(() => {
      this.products = this.products.filter((p) => p.id !== id);
      window.location.reload();
    })
  }

}
