import { Component, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { UserPassword } from 'src/app/interfaces/userPassword';


@Component({
  selector: 'app-change-password-dialog',
  templateUrl: './change-password-dialog.component.html',
  styleUrls: ['./change-password-dialog.component.css']
})
export class ChangePasswordDialogComponent {
  changePasswordForm: FormGroup;

  constructor(
    private dialogRef: MatDialogRef<ChangePasswordDialogComponent>,
    private formBuilder: FormBuilder,
    @Inject(MAT_DIALOG_DATA) public data: UserPassword
  ) {
    this.changePasswordForm = this.formBuilder.group({
      oldPassword: ['', Validators.required],
      newPassword: ['', [Validators.required, Validators.minLength(6)]],
      verifyNewPassword: ['', Validators.required]
    });
  }

  get formControls() {
    return this.changePasswordForm.controls;
  }

  onSubmit(): void {
    if (this.changePasswordForm.invalid) {
      return;
    }

    const passwordData: UserPassword = {
      oldPassword: this.formControls['oldPassword'].value,
      newPassword: this.formControls['newPassword'].value,
      verifyNewPassword: this.formControls['verifyNewPassword'].value
    };

    this.dialogRef.close(passwordData);
  }

  onCancel(): void {
    this.dialogRef.close();
  }
}
