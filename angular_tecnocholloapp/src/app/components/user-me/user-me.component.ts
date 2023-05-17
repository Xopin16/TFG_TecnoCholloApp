import { Component, OnInit } from '@angular/core';
import { User } from 'src/app/interfaces/user';
import { TokenStorageService } from 'src/app/services/token-storage.service';
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-user-me',
  templateUrl: './user-me.component.html',
  styleUrls: ['./user-me.component.css']
})
export class UserMeComponent implements OnInit {

  user!: User;
  isLoggedIn = false;
  username?: string; 

  constructor(private userService: UserService, private tokenStorageService: TokenStorageService) { }

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

  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }

}
