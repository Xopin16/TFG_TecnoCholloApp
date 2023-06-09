import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Product } from 'src/app/interfaces/product';
import { ProductService } from 'src/app/services/product.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';
import { EditProductDialogComponent } from '../edit-product-dialog/edit-product-dialog.component';
import { MatDialog } from '@angular/material/dialog';
import { DeleteProductDialogComponent } from '../delete-product-dialog/delete-product-dialog.component';

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

  constructor(private productService: ProductService, private route: ActivatedRoute, 
    private tokenStorageService: TokenStorageService, private dialog: MatDialog, private router: Router) { }

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

  openEditProductDialog(id: number): void {
    this.productService.getProductId(id).subscribe((product: Product) => {
      const dialogRef = this.dialog.open(EditProductDialogComponent, {
        width: '300px',
        data: product
      });
  
      dialogRef.afterClosed().subscribe(result => {
        if (result) {
          this.productService.putProduct(result, id).subscribe(() => {
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
        this.productService.deleteProduct(result).subscribe(() => {
          this.router.navigate(['/product']);
        })
      }
    })
  }
  

  // deleteProduct(id: number){
  //   this.productService.deleteProduct(id).subscribe(() => {
  //     this.products = this.products.filter((p) => p.id !== id);
  //     window.location.reload();
  //   })
  // }

  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }
}
