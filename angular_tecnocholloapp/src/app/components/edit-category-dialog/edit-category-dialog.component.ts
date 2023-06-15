import { Component, Inject, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
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
    @Inject(MAT_DIALOG_DATA) public data: Category,
    private snackBar: MatSnackBar) { 
      this.editCategoryForm.patchValue(data);
    }

    onSave(): void{
      const updateCategory: Category = {
        nombre: this.editCategoryForm.value.nombre
      }
      this.dialogRef.close(updateCategory);
      this.showSuccessMessage('Categoría guardada con éxito');
    }
  
    onCancel(): void {
      this.dialogRef.close();
    }
  
    showSuccessMessage(message: string): void {
      this.snackBar.open(message, 'Cerrar', {
        duration: 3000,
        panelClass: 'success-snackbar'
      });
    }
  

}
