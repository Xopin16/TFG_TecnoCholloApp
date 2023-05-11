import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Product, ProductResponse } from '../interfaces/product';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ProductService {

  constructor(private http: HttpClient) { }

  getProducts(page: number): Observable<ProductResponse>{
    const headers = new HttpHeaders({
      'Authorization': `Bearer ${environment.token}`
    });
    return this.http.get<ProductResponse>(`http://localhost:8080/producto/?page=${page}`, {headers});
  }
}
