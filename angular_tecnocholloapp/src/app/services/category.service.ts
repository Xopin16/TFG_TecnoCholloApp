import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Category } from '../interfaces/category';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CategoryService {

  constructor(private http: HttpClient) { }

  getCategories(page: number): Observable<Category[]>{
    return this.http.get<Category[]>(`https://localhost:8080/categoria/?page=${page}`);
  }
}
