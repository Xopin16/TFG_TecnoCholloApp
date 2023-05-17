import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Category } from 'src/app/interfaces/category';
import { CategoryService } from 'src/app/services/category.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';

@Component({
  selector: 'app-edit-category',
  templateUrl: './edit-category.component.html',
  styleUrls: ['./edit-category.component.css']
})
export class EditCategoryComponent implements OnInit {

  id!: number;
  updateCategory!: Category;
  isLoggedIn = false;
  username?: string; 

  constructor(private categoryService: CategoryService, private tokenStorageService: TokenStorageService,
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
    this.categoryService.getCategoryId(id).subscribe((category) => {
      this.updateCategory = category;
    });
  }

  editCategory() {
    this.categoryService.putCategory(this.updateCategory, this.id)
      .subscribe(
        response => {
          this.router.navigate(['/category']);
        },
        error => {
          console.error('Error updating product:', error);
        }
      );
  }

  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }

}
