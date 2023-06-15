import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

//const AUTH_API = 'http://localhost:8080/api/auth/';
const AUTH_API = 'http://localhost:8080/auth/'

const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  constructor(private http: HttpClient) { }

  login(username: string, password: string): Observable<any> {
    //return this.http.post(AUTH_API + 'signin', {
    return this.http.post(AUTH_API + 'login', {
      username,
      password
    }, httpOptions);
  }

  register(username: string, fullName: string, password: string, verifyPassword: string,  email: string, verifyEmail: string): Observable<any> {
    //return this.http.post(AUTH_API + 'signup', {
    return this.http.post(AUTH_API + 'register/admin', {
      username,
      fullName,
      password,
      verifyPassword,
      email,
      verifyEmail
    }, httpOptions);
  }
}
