import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Product } from 'src/app/interfaces/product';
import { ProductService } from 'src/app/services/product.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';

@Component({
  selector: 'app-product-detail',
  templateUrl: './product-detail.component.html',
  styleUrls: ['./product-detail.component.css']
})
export class ProductDetailComponent implements OnInit {

  product: any;
  id: any;
  isLoggedIn = false;
  username?: string; 

  constructor(private productService: ProductService, private route: ActivatedRoute, private tokenStorageService: TokenStorageService) { }

  ngOnInit(): void {
    this.isLoggedIn = !!this.tokenStorageService.getToken();
    if(this.isLoggedIn){
      const user = this.tokenStorageService.getUser();
      this.username = user.username;
    }
    this.route.params.subscribe(params => {
      this.id = params['id'];
    });
    console.log(this.id)
    this.productService.getProductId(Number(this.id)).subscribe((resp) =>{
      this.product = resp;
    })
  }

  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }
}
