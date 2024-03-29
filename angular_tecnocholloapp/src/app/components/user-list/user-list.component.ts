import { Component, OnInit } from '@angular/core';
import { User } from 'src/app/interfaces/user';
import { TokenStorageService } from 'src/app/services/token-storage.service';
import { UserService } from 'src/app/services/user.service';
import { DeleteUserDialogComponent } from '../delete-user-dialog/delete-user-dialog.component';
import { MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-user-list',
  templateUrl: './user-list.component.html',
  styleUrls: ['./user-list.component.css']
})
export class UserListComponent implements OnInit {
  
  users: User[] = [];
  displayedColumns: string[] = ['username', 'fullname', 'email', 'acciones'];
  isLoggedIn = false;
  username?: string;
  numPages = 0;
  currentPage = 0; 

  constructor(private userService: UserService, private tokenStorageService: TokenStorageService, 
    private dialog: MatDialog) { }
  

  ngOnInit(): void {
    this.isLoggedIn = !!this.tokenStorageService.getToken();
    if(this.isLoggedIn){
      const user = this.tokenStorageService.getUser();
      this.username = user.username;
    }
    this.getUsers(0);
  }

  getUsers(page: number){
    this.userService.getUsers(page).subscribe((resp) => {
      this.users = resp.content.filter(u=> u.username != this.username);
      this.numPages = resp.totalPages;
      this.currentPage = page;
      console.log(resp)
    });
  }

  getPage(page: number) {
    if (page >= 0 && page < this.numPages ) {
      this.userService.getUsers(page).subscribe((resp) => {
        this.users = resp.content.filter(u=> u.username != this.username);
        this.numPages = resp.totalPages;
        this.currentPage = page;
      });
    }
  }

  deleteUser(id: string){
    this.userService.deleteUser(id).subscribe(() => {
      this.users = this.users.filter((user) => user.id !== id);
      window.location.reload();
    })
  }

  openDeleteUserDialog(id: number): void{
    const dialogRef = this.dialog.open(DeleteUserDialogComponent, {
      width:'250px',
      data: { id: id }
    });
  
    dialogRef.afterClosed().subscribe(result => {
      if(result){
        this.deleteUser(result);
      }
    })
  }

  logout(): void {
    this.tokenStorageService.signOut();
  }
}
