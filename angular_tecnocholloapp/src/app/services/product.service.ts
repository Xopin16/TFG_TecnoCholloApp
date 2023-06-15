import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Product, ProductResponse } from '../interfaces/product';
import { environment } from 'src/environments/environment';
import { DatePipe, formatDate } from '@angular/common';
import { CreateProduct } from '../interfaces/createProduct';

const TOKEN = window.sessionStorage.getItem('auth-token');
const headers = new HttpHeaders({
  'Authorization': `Bearer ${TOKEN}`
})

@Injectable({
  providedIn: 'root'
})
export class ProductService {

  constructor(private http: HttpClient) { }

  getProducts(page: number, nombre?: string): Observable<ProductResponse> {
    let url = `http://localhost:8080/producto/?page=${page}`;
  
    if (nombre) {
      url += `&s=nombre:${nombre}`;
    }
  
    return this.http.get<ProductResponse>(url, { headers });
  }
  

  getProductId(id: number): Observable<Product>{
    return this.http.get<Product>(`http://localhost:8080/producto/${id}`, {headers})
  }

  postProduct(body: CreateProduct, file: File): Observable<Product>{

    let formData = new FormData();
    formData.append('body', new Blob([JSON.stringify(body)], {
      type: "application/json",
    }));
    formData.append('file', file, file.name);
    
    return this.http.post<Product>(`http://localhost:8080/product`, formData, {headers})
  }

  putProduct(body: CreateProduct, id: number, file: File): Observable<Product>{
    let formData = new FormData();
    formData.append('body', new Blob([JSON.stringify(body)], {
      type: "application/json",
    }));
    formData.append('file', file, file.name);
    return this.http.put<Product>(`http://localhost:8080/usuario/product/${id}`, formData, {headers})
  }

  deleteProduct(id: number): Observable<void>{
    return this.http.delete<void>(`http://localhost:8080/admin/producto/${id}`, {headers})
  }

}
