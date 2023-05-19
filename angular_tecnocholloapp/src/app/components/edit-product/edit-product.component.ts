import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Product } from 'src/app/interfaces/product';
import { ProductService } from 'src/app/services/product.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';

@Component({
  selector: 'app-edit-product',
  templateUrl: './edit-product.component.html',
  styleUrls: ['./edit-product.component.css']
})
export class EditProductComponent implements OnInit {

  // productForm: FormGroup = new FormGroup({
  //   nombre: new FormControl('', Validators.required),
  //   precio: new FormControl('', Validators.required),
  //   descripcion: new FormControl('', Validators.required)
  // });

  id!: number;
  updateProduct!: Product;
  isLoggedIn = false;
  username?: string; 

  constructor(private productService: ProductService, private tokenStorageService: TokenStorageService,
    private router: Router, private route: ActivatedRoute) { }

  ngOnInit(): void {
    this.isLoggedIn = !!this.tokenStorageService.getToken();
    if(this.isLoggedIn){
      const user = this.tokenStorageService.getUser();
      this.username = user.username;
    }
    this.route.params.subscribe(params => {
      this.id = +params['id'];
      this.getProduct(this.id);
    });
  }

  getProduct(id: number) {
    this.productService.getProductId(id).subscribe((product) => {
      this.updateProduct = product;
    });
  }

  editProduct() {
    this.productService.putProduct(this.updateProduct, this.id)
      .subscribe(
        response => {
          console.log('Product updated successfully');
          this.router.navigate(['/product']);
        },
        error => {
          console.error('Error updating product:', error);
          // Maneja el error de alguna manera, como mostrar un mensaje de error al usuario
        }
      );
  }

  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }
  

}
