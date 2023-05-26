import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { User, UserResponse } from '../interfaces/user';
import { Observable } from 'rxjs';
import { CreateUser } from '../interfaces/createUser';

const TOKEN = window.sessionStorage.getItem('auth-token');
const headers = new HttpHeaders({
  'Authorization': `Bearer ${TOKEN}`
}).append('Content-Type', 'application/json');

@Injectable({
  providedIn: 'root'
})
export class UserService {

  constructor(private http: HttpClient) { }

  getUsers(page: number): Observable<UserResponse>{
    return this.http.get<UserResponse>(`http://localhost:8080/usuario/?page=${page}`, {headers});
  }

  getProfile(): Observable<User>{
    return this.http.get<User>(`http://localhost:8080/usuario/me`, {headers});
  }

  getUserById(id: string): Observable<User>{
    return this.http.get<User>(`http://localhost:8080/usuario/${id}`, {headers});
  }

  changePassword(): Observable<User>{
    return this.http.get<User>(`http://localhost:8080/user/changePassword`, {headers});
  }

  deleteAccount(): Observable<void>{
    return this.http.delete<void>(`http://localhost:8080/usuario/`, {headers});
  }

  deleteUser(id: string): Observable<void>{
    return this.http.delete<void>(`http://localhost:8080/admin/usuario/${id}`, {headers});
  }

  registerAdmin(user: CreateUser): Observable<CreateUser>{
    return this.http.post<CreateUser>(`http://localhost:8080/auth/register/admin`, user, {headers});
  }
}
