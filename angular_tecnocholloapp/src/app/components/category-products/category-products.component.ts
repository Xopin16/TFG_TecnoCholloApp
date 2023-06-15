import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { Product } from 'src/app/interfaces/product';
import { CategoryService } from 'src/app/services/category.service';
import { ProductService } from 'src/app/services/product.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';
import { EditProductDialogComponent } from '../edit-product-dialog/edit-product-dialog.component';
import { DeleteProductDialogComponent } from '../delete-product-dialog/delete-product-dialog.component';

@Component({
  selector: 'app-category-products',
  templateUrl: './category-products.component.html',
  styleUrls: ['./category-products.component.css']
})
export class CategoryProductsComponent implements OnInit {

  id: number = 0;
  products: Product[] = [];
  displayedColumns: string[] = ['imagen', 'nombre', 'precio', 'descripcion', 'acciones'];
  isLoggedIn = false;
  username?: string;
  numPages = 0;
  currentPage = 0; 

  constructor(private categoryService: CategoryService, private tokenStorageService: TokenStorageService,
    private router: Router, private route: ActivatedRoute, private productService: ProductService, private dialog: MatDialog) { }

  ngOnInit(): void {
    this.isLoggedIn = !!this.tokenStorageService.getToken();
    if(this.isLoggedIn){
      const user = this.tokenStorageService.getUser();
      this.username = user.username;
    }
    this.route.params.subscribe(params => {
      this.id = +params['id'];
    });
    this.getCategoryProducts(0);
  }

  getPage(page: number) {
    if (page >= 0 && page < this.numPages ) {
      this.categoryService.getCategoryProducts(this.id, page).subscribe(resp => {
        this.products = resp.content;
        this.numPages = resp.totalPages;
        this.currentPage = page;
      });
    }
  }

  getCategoryProducts(page: number): void{
    this.categoryService.getCategoryProducts(this.id, page)      .subscribe(
      response => {
        this.products = response.content;
        this.numPages = response.totalPages;
        this.currentPage = page;
        console.log(response);
      },
      error => {
        console.error('Error updating product:', error);
      }
    );
  }

  logout(): void {
    this.tokenStorageService.signOut();
  }

  openEditProductDialog(id: number): void {
    this.productService.getProductId(id).subscribe((product: Product) => {
      const dialogRef = this.dialog.open(EditProductDialogComponent, {
        width: '300px',
        data: product
      });
  
      dialogRef.afterClosed().subscribe(result => {
        if (result) {
          const product = result;
          this.productService.putProduct(product, id).subscribe(() => {
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
