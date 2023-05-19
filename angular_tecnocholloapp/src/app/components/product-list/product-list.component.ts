import { Component, OnInit } from '@angular/core';
import { Product } from 'src/app/interfaces/product';
import { ProductService } from 'src/app/services/product.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';

@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.css']
})
export class ProductListComponent implements OnInit {
  
  products: Product[] = [];
  displayedColumns: string[] = ['imagen', 'nombre', 'precio', 'descripcion', 'acciones'];
  isLoggedIn = false;
  username?: string; 
  numPages = 0;
  currentPage = 0;

  constructor(private productService: ProductService, private tokenStorageService: TokenStorageService ) { }

  ngOnInit(): void {
    this.isLoggedIn = !!this.tokenStorageService.getToken();
    if(this.isLoggedIn){
      const user = this.tokenStorageService.getUser();
      this.username = user.username;
    }
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

  getProducts(page: number): void{
    this.productService.getProducts(page).subscribe((resp) => {
      this.products = resp.content;
      this.numPages = resp.totalPages;
      this.currentPage = page;
      console.log(resp)
    });
  }

  logout(): void {
    this.tokenStorageService.signOut();
  }

  deleteProduct(id: number){
    this.productService.deleteProduct(id).subscribe(() => {
      this.products = this.products.filter((p) => p.id !== id);
      window.location.reload();
    })
  }

}
