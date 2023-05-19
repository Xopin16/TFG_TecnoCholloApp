import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { TokenStorageService } from 'src/app/services/token-storage.service';
import { UserService } from 'src/app/services/user.service';

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

  constructor(private userService: UserService, private route: ActivatedRoute, private tokenStorageService: TokenStorageService) { }

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

  logout(): void {
    this.tokenStorageService.signOut();
    // window.location.reload();
  }

}
