import { Component, Inject, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Category } from 'src/app/interfaces/category';

@Component({
  selector: 'app-edit-category-dialog',
  templateUrl: './edit-category-dialog.component.html',
  styleUrls: ['./edit-category-dialog.component.css']
})
export class EditCategoryDialogComponent {

  editCategoryForm: FormGroup = new FormGroup({
    nombre: new FormControl('', Validators.required)
  })

  constructor(private dialogRef: MatDialogRef<EditCategoryDialogComponent>, 
    @Inject(MAT_DIALOG_DATA) public data: Category) { 
      this.editCategoryForm.patchValue(data);
    }

    onSave(): void{
      const updateCategory: Category = {
        nombre: this.editCategoryForm.value.nombre
      }
      this.dialogRef.close(updateCategory);
    }
  
    onCancel(): void {
      this.dialogRef.close();
    }
  

}
