import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Category } from 'src/app/interfaces/category';
import { Product } from 'src/app/interfaces/product';
import { CategoryService } from 'src/app/services/category.service';
import { ProductService } from 'src/app/services/product.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';

@Component({
  selector: 'app-new-product',
  templateUrl: './new-product.component.html',
  styleUrls: ['./new-product.component.css']
})
export class NewProductComponent implements OnInit {

  categories: Category[] = [];
  idCategoria: number = 0;
  newProduct: Product = {nombre: '', precio: 0, descripcion: '', idCategory: 0};
  isLoggedIn = false;
  username?: string; 

  constructor(private productService: ProductService, private categoryService: CategoryService,
     private tokenStorageService: TokenStorageService, private router: Router, private route: ActivatedRoute) { }

  ngOnInit(): void {
    this.isLoggedIn = !!this.tokenStorageService.getToken();
    if(this.isLoggedIn){
      const user = this.tokenStorageService.getUser();
      this.username = user.username;
    }
    this.categoryService.getCategories(0).subscribe((resp) => {
      this.categories = resp.content;
      console.log(resp)
    });
  }

  onSubmit(){
    this.productService.postProduct(this.newProduct, this.idCategoria).subscribe((product) => {
      this.newProduct = {nombre: '', precio: 0, descripcion: '', idCategory: 0}
    });
    this.router.navigate(['/product'])
  }

  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }

}
