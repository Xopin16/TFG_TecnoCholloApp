import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';
import { TokenStorageService } from 'src/app/services/token-storage.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
  form: any = {
      username: null,
      fullName: null, 
      password: null, 
      verifyPassword: null, 
      email: null, 
      verifyEmail: null
  }
  // isLoggedIn = false;
  isLoginFailed = false;
  errorMessage = '';
  roles: string[] = [];

  constructor(private authService: AuthService, private tokenStorage: TokenStorageService, private router: Router) { }

  ngOnInit(): void {
    // if (this.tokenStorage.getToken()) {
    //   // var token = this.tokenStorage.getToken();
    //   // console.log(token);
    //   this.isLoggedIn = true;
    //   //this.roles = this.tokenStorage.getUser().roles;
    //   // this.roles = ['ROLE_USER'];
    // }
  }

  onSubmit(): void {
    const { username, fullName, password, verifyPassword, email, verifyEmail} = this.form;

    this.authService.register(username, fullName, password, verifyPassword, email, verifyEmail).subscribe({
      next: data => {
        this.tokenStorage.saveToken(data.token);
        this.tokenStorage.saveUser(data);
        this.isLoginFailed = false;
        // this.isLoggedIn = true;
        this.router.navigate(['/login']).then(() => {
          window.location.reload();
        });
      },
      error: err => {
        this.errorMessage = err.error.message;
        this.isLoginFailed = true;
        console.log(err);
      }
    });
  }

  reloadPage(): void {
    window.location.reload();
  }

}
