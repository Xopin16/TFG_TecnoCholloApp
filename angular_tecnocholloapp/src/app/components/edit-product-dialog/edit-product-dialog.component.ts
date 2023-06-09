import { Component, OnInit, Inject} from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Product } from 'src/app/interfaces/product';

@Component({
  selector: 'app-edit-product-dialog',
  templateUrl: './edit-product-dialog.component.html',
  styleUrls: ['./edit-product-dialog.component.css']
})
export class EditProductDialogComponent{

  editProductForm: FormGroup = new FormGroup({
    nombre: new FormControl('', Validators.required),
    precio: new FormControl('', Validators.required),
    descripcion: new FormControl('', Validators.required),
    cantidad: new FormControl('', Validators.required)
  })

  constructor(private dialogRef: MatDialogRef<EditProductDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Product) { 
      this.editProductForm.patchValue(data);
    }

  
  onSave(): void{
    const updateProduct: Product = {
      nombre: this.editProductForm.value.nombre,
      precio: this.editProductForm.value.precio,
      descripcion: this.editProductForm.value.descripcion,
      cantidad: this.editProductForm.value.cantidad
    }
    this.dialogRef.close(updateProduct);
  }

  onCancel(): void {
    this.dialogRef.close();
  }


}
