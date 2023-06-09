import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-category-dialog',
  templateUrl: './delete-category-dialog.component.html',
  styleUrls: ['./delete-category-dialog.component.css']
})
export class DeleteCategoryDialogComponent {

  constructor(@Inject(MAT_DIALOG_DATA) public data: { id: number }, private dialogRef: MatDialogRef<DeleteCategoryDialogComponent>){}

  onDelete(){
    this.dialogRef.close(this.data.id);
  }

}
