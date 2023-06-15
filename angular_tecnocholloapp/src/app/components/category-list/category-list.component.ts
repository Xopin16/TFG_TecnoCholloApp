import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Category } from 'src/app/interfaces/category';
import { CategoryService } from 'src/app/services/category.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';
import { CreateCategoryDialogComponent } from '../create-category-dialog/create-category-dialog.component';
import { EditCategoryDialogComponent } from '../edit-category-dialog/edit-category-dialog.component';
import { DeleteCategoryDialogComponent } from '../delete-category-dialog/delete-category-dialog.component';

@Component({
  selector: 'app-category-list',
  templateUrl: './category-list.component.html',
  styleUrls: ['./category-list.component.css']
})
export class CategoryListComponent implements OnInit {

  categories: Category[] = [];
  displayedColumns: string[] = ['imagen', 'nombre', 'acciones'];
  categoria: Category = {nombre: ''}
  isLoggedIn = false;
  username?: string;
  numPages = 0;
  currentPage = 0; 

  constructor(private categoryService: CategoryService, private tokenStorageService: TokenStorageService, 
    private dialog: MatDialog) { }

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

  openCreateCategoryDialog(): void{
    const dialogRef = this.dialog.open(CreateCategoryDialogComponent, {
      width: '300px',
      data: this.categoria
    });
  
    dialogRef.afterClosed().subscribe((result: any) => {
      if (result) {
        this.categoryService.postCategory(result).subscribe(() => {
          this.categoria = result;
        });
      }
    });
  }

  openEditCategoryDialog(id: number): void{
    this.categoryService.getCategoryId(id).subscribe((category: Category) => {
      const dialogRef = this.dialog.open(EditCategoryDialogComponent, {
        width: '300px',
        data: category
      });

      dialogRef.afterClosed().subscribe(result => {
      if(result){
        this.categoryService.putCategory(result, id).subscribe(() => {
          window.location.reload()
        })
      }
      })
    })
  }

  openDeleteCategoryDialog(id: number): void{
    const dialogRef = this.dialog.open(DeleteCategoryDialogComponent, {
      width:'250px',
      data: { id: id }
    });

    dialogRef.afterClosed().subscribe(result => {
      if(result){
        this.deleteCategory(result);
      }
    })
  }

  deleteCategory(id: number){
    this.categoryService.deleteCategory(id).subscribe(()=>{
      this.categories = this.categories.filter((c) => c.id !== id);
      window.location.reload();
    })
  }
}


