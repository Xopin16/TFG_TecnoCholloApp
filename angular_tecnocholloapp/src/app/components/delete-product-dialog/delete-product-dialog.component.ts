import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-product-dialog',
  templateUrl: './delete-product-dialog.component.html',
  styleUrls: ['./delete-product-dialog.component.css']
})
export class DeleteProductDialogComponent {

  constructor(@Inject(MAT_DIALOG_DATA) public data: { id: number }, private dialogRef: MatDialogRef<DeleteProductDialogComponent>){}

  onDelete(){
    this.dialogRef.close(this.data.id);
  }

  onCancel(): void {
    this.dialogRef.close();
  }
}
