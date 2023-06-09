import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-user-dialog',
  templateUrl: './delete-user-dialog.component.html',
  styleUrls: ['./delete-user-dialog.component.css']
})
export class DeleteUserDialogComponent {

  constructor(@Inject(MAT_DIALOG_DATA) public data: { id: number }, private dialogRef: MatDialogRef<DeleteUserDialogComponent>){}

  onDelete(){
    this.dialogRef.close(this.data.id);
  }

}
