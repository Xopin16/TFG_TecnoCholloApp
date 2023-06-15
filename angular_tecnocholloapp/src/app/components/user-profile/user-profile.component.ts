import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { TokenStorageService } from 'src/app/services/token-storage.service';
import { UserService } from 'src/app/services/user.service';
import { DeleteUserDialogComponent } from '../delete-user-dialog/delete-user-dialog.component';
import { MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-user-profile',
  templateUrl: './user-profile.component.html',
  styleUrls: ['./user-profile.component.css']
})
export class UserProfileComponent implements OnInit {

  user: any;
  id: any;
  isLoggedIn = false;
  username?: string; 

  constructor(private userService: UserService, private route: ActivatedRoute, 
    private tokenStorageService: TokenStorageService, private dialog: MatDialog, private router: Router) { }

  ngOnInit(): void {
    this.isLoggedIn = !!this.tokenStorageService.getToken();
    if(this.isLoggedIn){
      const user = this.tokenStorageService.getUser();
      this.username = user.username;
    }
    this.route.params.subscribe(params => {
      this.id = params['id'];
    });
    console.log(this.id)
    this.userService.getUserById(String(this.id)).subscribe((resp) =>{
      this.user = resp;
    })
  }
  
  openDeleteUserDialog(id: number): void{
    const dialogRef = this.dialog.open(DeleteUserDialogComponent, {
      width:'250px',
      data: { id: id }
    });
  
    dialogRef.afterClosed().subscribe(result => {
      if(result){
        this.userService.deleteUser(result).subscribe(() => {
          this.router.navigate(['/user'])
        });
      }
    })
  }

  decodeURIComponent(encodedName: string): string {
    const decodedName = this.decodeURIComponent(encodedName);
    return decodedName;
  }
  
  
  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }

}
