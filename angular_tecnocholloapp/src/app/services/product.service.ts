import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Product } from '../interfaces/product';

@Injectable({
  providedIn: 'root'
})
export class ProductService {

  constructor(private http: HttpClient) { }

  getProducts(page: number): Observable<Product[]>{
    return this.http.get<Product[]>(`https://localhost:8080/producto/?page=${page}`);
  }
}
