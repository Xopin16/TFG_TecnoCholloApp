import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Category, CategoryResponse } from '../interfaces/category';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ProductResponse } from '../interfaces/product';

const TOKEN = window.sessionStorage.getItem('auth-token');
const headers = new HttpHeaders({
  'Authorization': `Bearer ${TOKEN}`
}).append('Content-Type', 'application/json');

@Injectable({
  providedIn: 'root'
})
export class CategoryService {

  constructor(private http: HttpClient) { }

  getCategories(page: number): Observable<CategoryResponse>{
    return this.http.get<CategoryResponse>(`http://localhost:8080/categoria/?page=${page}`, {headers});
  }

  getCategoryId(id: number): Observable<Category>{
    return this.http.get<Category>(`http://localhost:8080/categoria/${id}`, {headers});
  }

  getCategoryProducts(id: number, page: number): Observable<ProductResponse>{
    return this.http.get<ProductResponse>(`http://localhost:8080/categoria/producto/${id}/?page=${page}`, {headers});
  }

  postCategory(category: Category): Observable<Category>{
    return this.http.post<Category>(`http://localhost:8080/admin/categoria/`, category, {headers});
  }

  putCategory(category: Category, id: number): Observable<Category>{
    return this.http.put<Category>(`http://localhost:8080/admin/categoria/${id}`, category, {headers});
  }

  deleteCategory(id: number): Observable<void>{
    return this.http.delete<void>(`http://localhost:8080/admin/categoria/${id}`, {headers});
  }
}
