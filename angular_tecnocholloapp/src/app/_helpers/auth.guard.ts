import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { TokenStorageService } from '../services/token-storage.service';

@Injectable({
  providedIn: 'root',
})
export class AuthGuard implements CanActivate {
  constructor(
    private tokenStorageService: TokenStorageService,
    private router: Router
  ) {}

  canActivate(): boolean {
    if (this.tokenStorageService.getToken()) {
        console.log("Se envia true")
      return true;
    } else {
      this.router.navigate(['/login']);
      return false;
    }
  }
}
