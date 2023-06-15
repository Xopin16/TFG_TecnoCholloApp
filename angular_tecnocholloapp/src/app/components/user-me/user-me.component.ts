import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { User } from 'src/app/interfaces/user';
import { TokenStorageService } from 'src/app/services/token-storage.service';
import { UserService } from 'src/app/services/user.service';
import { UserPassword } from 'src/app/interfaces/userPassword';
import { Router } from '@angular/router';
import { ChangePasswordDialogComponent } from '../change-password-dialog/change-password-dialog.component';
import { DeleteAccountDialogComponent } from '../delete-account-dialog/delete-account-dialog.component';

@Component({
  selector: 'app-user-me',
  templateUrl: './user-me.component.html',
  styleUrls: ['./user-me.component.css']
})
export class UserMeComponent implements OnInit {

  user!: User;
  updatePassword: UserPassword = {oldPassword: '', newPassword: '', verifyNewPassword: ''}
  isLoggedIn = false;
  username?: string; 

  constructor(private userService: UserService, private tokenStorageService: TokenStorageService, private dialog: MatDialog, private router: Router) { }

  ngOnInit(): void {
    this.isLoggedIn = !!this.tokenStorageService.getToken();
    if(this.isLoggedIn){
      const user = this.tokenStorageService.getUser();
      this.username = user.username;
    }
    this.userService.getProfile().subscribe((resp) => {
      this.user = resp;
    })
  }

  
openChangePasswordDialog(): void {
  const dialogRef = this.dialog.open(ChangePasswordDialogComponent, {
    width: '300px',
    data: this.updatePassword
    // data: this.userPassword
  });

  dialogRef.afterClosed().subscribe(result => {
    if (result) {
      this.updatePassword = {
        oldPassword: result.oldPassword,
        newPassword: result.newPassword,
        verifyNewPassword: result.verifyNewPassword
      };

      this.userService.changePassword(this.updatePassword)
      .subscribe(
        resp => {
          this.router.navigate(['/login'])
        },
        error => {
          console.error('Error updating password:', error)
        }
      );
    }
  });
}

deleteAccount(): void {
  this.userService.deleteAccount().subscribe((_)=>{
    this.router.navigate(['/login']);
  })
}

openDeleteAccountDialog(): void{
  const dialogRef = this.dialog.open(DeleteAccountDialogComponent, {
    width: '250px'
  });

  dialogRef.afterClosed().subscribe((result)=>{
    if(result === false){
      return;
    }
    this.deleteAccount();
  });
}

logout(): void {
  this.tokenStorageService.signOut();
  // window.location.reload();
}

}
