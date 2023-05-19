import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Category } from 'src/app/interfaces/category';
import { CategoryService } from 'src/app/services/category.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';

@Component({
  selector: 'app-new-category',
  templateUrl: './new-category.component.html',
  styleUrls: ['./new-category.component.css']
})
export class NewCategoryComponent implements OnInit {

  newCategory: Category = {nombre: ''}
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
  }

  onSubmit(){
    this.categoryService.postCategory(this.newCategory).subscribe((resp)=>{
      this.newCategory = {nombre: ''}
    });
    this.router.navigate(['/category']);
  }

  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }

}
