import { Component, OnInit, Inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Category } from 'src/app/interfaces/category';
import { CategoryService } from 'src/app/services/category.service';

@Component({
  selector: 'app-create-category-dialog',
  templateUrl: './create-category-dialog.component.html',
  styleUrls: ['./create-category-dialog.component.css']
})
export class CreateCategoryDialogComponent {

  createCategoryForm: FormGroup;

  constructor(private dialogRef: MatDialogRef<CreateCategoryDialogComponent>,
    private formBuilder: FormBuilder, private categoryService: CategoryService,
    @Inject(MAT_DIALOG_DATA) public data: Category) {
      this.createCategoryForm = this.formBuilder.group({
        nombre: ['', Validators.required]
      });
     }

     get formControls() {
      return this.createCategoryForm.controls;
    }
    
     onSubmit(): void {
      if (this.createCategoryForm.invalid) {
        return;
      }
  
      const categoryData: Category = {
        nombre: this.formControls['nombre'].value
      };
  
      this.dialogRef.close(categoryData);
    }
  
    onCancel(): void {
      this.dialogRef.close();
    }


}
