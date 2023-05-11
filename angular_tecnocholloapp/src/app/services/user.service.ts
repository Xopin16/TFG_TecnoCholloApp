import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { User } from '../interfaces/user';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class UserService {

  constructor(private http: HttpClient) { }

  getUsers(page: number): Observable<User[]>{
    return this.http.get<User[]>(`https://localhost:8080/usuario/?page=${page}`);
  }
}
