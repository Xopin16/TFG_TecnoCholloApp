import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Category } from 'src/app/interfaces/category';
import { Product } from 'src/app/interfaces/product';
import { CategoryService } from 'src/app/services/category.service';

@Component({
  selector: 'app-create-product-dialog',
  templateUrl: './create-product-dialog.component.html',
  styleUrls: ['./create-product-dialog.component.css']
})
export class CreateProductDialogComponent implements OnInit{

  createProductForm: FormGroup;
  categories: Category[] = [];
  

  constructor(private dialogRef: MatDialogRef<CreateProductDialogComponent>,
    private formBuilder: FormBuilder, private categoryService: CategoryService,
    @Inject(MAT_DIALOG_DATA) public data: Product) { 
      this.createProductForm = this.formBuilder.group({
        nombre: ['', Validators.required],
        precio: ['', Validators.required],
        descripcion: ['', Validators.required],
        cantidad: ['', Validators.required],
        idCategory: ['', Validators.required]  // Cambiar 'categoria' a 'idCategory'
      });
      
    }
    
    ngOnInit(): void {
      this.categoryService.getCategories(0).subscribe((resp) => {
        this.categories = resp.content;
        console.log(resp)
      });
    }

    get formControls() {
      return this.createProductForm.controls;
    }
  
    onSubmit(): void {
      if (this.createProductForm.invalid) {
        return;
      }
  
      const productData: Product = {
        nombre: this.formControls['nombre'].value,
        precio: this.formControls['precio'].value,
        descripcion: this.formControls['descripcion'].value,
        cantidad: this.formControls['cantidad'].value,
        idCategory: this.formControls['idCategory'].value
      };
  
      this.dialogRef.close(productData);
    }
  
    onCancel(): void {
      this.dialogRef.close();
    }

}