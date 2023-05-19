import { Component, OnInit } from '@angular/core';
import { Category } from 'src/app/interfaces/category';
import { CategoryService } from 'src/app/services/category.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';

@Component({
  selector: 'app-category-list',
  templateUrl: './category-list.component.html',
  styleUrls: ['./category-list.component.css']
})
export class CategoryListComponent implements OnInit {

  categories: Category[] = [];
  displayedColumns: string[] = ['imagen', 'nombre', 'acciones'];
  isLoggedIn = false;
  username?: string;
  numPages = 0;
  currentPage = 0; 

  constructor(private categoryService: CategoryService, private tokenStorageService: TokenStorageService ) { }

  ngOnInit(): void {
    this.isLoggedIn = !!this.tokenStorageService.getToken();
    if(this.isLoggedIn){
      const user = this.tokenStorageService.getUser();
      this.username = user.username;
    }
    this.getCategories(0);
  }

  getPage(page: number) {
    if (page >= 0 && page < this.numPages ) {
      this.categoryService.getCategories(page).subscribe(resp => {
        this.categories = resp.content;
        this.numPages = resp.totalPages;
        this.currentPage = page;
      });
    }
  }

  getCategories(page: number){
    this.categoryService.getCategories(page).subscribe((resp) => {
      this.categories = resp.content;
      this.numPages = resp.totalPages;
      this.currentPage = page;
    });
  }

  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }

  deleteCategory(id: number){
    this.categoryService.deleteCategory(id).subscribe(()=>{
      this.categories = this.categories.filter((c) => c.id !== id);
      window.location.reload();
    })
  }
}


