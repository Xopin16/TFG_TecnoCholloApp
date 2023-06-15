import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Category } from 'src/app/interfaces/category';
import { CreateProduct } from 'src/app/interfaces/createProduct';
import { Product } from 'src/app/interfaces/product';
import { CategoryService } from 'src/app/services/category.service';

@Component({
  selector: 'app-create-product-dialog',
  templateUrl: './create-product-dialog.component.html',
  styleUrls: ['./create-product-dialog.component.css']
})
export class CreateProductDialogComponent implements OnInit{

  // createProductForm: FormGroup;
  body: CreateProduct = {
    nombre: '',
    precio: 0,
    descripcion: '',
    cantidad: 0,
    categoria: ''
  }
  categories: Category[] = [];
  categoria: string = "";
  file: File | null = null;
  

  constructor(private dialogRef: MatDialogRef<CreateProductDialogComponent>,
    private formBuilder: FormBuilder, private categoryService: CategoryService,
    @Inject(MAT_DIALOG_DATA) public data: CreateProduct) { 
      // this.createProductForm = this.formBuilder.group({
      //   nombre: ['', Validators.required],
      //   precio: ['', Validators.required],
      //   descripcion: ['', Validators.required],
      //   cantidad: ['', Validators.required],
      //   categoria: ['', Validators.required]
      // });
      
    }
    
    ngOnInit(): void {
      this.categoryService.getCategories(0).subscribe((resp) => {
        this.categories = resp.content;
        console.log(resp)
      });
    }

    selectFile(event: any): void{
      const file = event.target.files[0];
      this.file = file;
    }

    // get formControls() {
    //   return this.createProductForm.controls;
    // }
  
    onSubmit(): void {
      // if (this.createProductForm.invalid) {
      //   return;
      // }

      const productData: CreateProduct = {
        nombre: this.body.nombre,
        precio: this.body.precio,
        descripcion: this.body.descripcion,
        cantidad: this.body.cantidad,
        categoria: this.body.categoria
      };
  
      this.dialogRef.close({body: productData, file: this.file});
    }
  
    onCancel(): void {
      this.dialogRef.close();
    }

}
