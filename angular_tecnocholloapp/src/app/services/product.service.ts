import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Product, ProductResponse } from '../interfaces/product';
import { environment } from 'src/environments/environment';
import { DatePipe, formatDate } from '@angular/common';

const TOKEN = window.sessionStorage.getItem('auth-token');
const headers = new HttpHeaders({
  'Authorization': `Bearer ${TOKEN}`
}).append('Content-Type', 'application/json');

@Injectable({
  providedIn: 'root'
})
export class ProductService {

  constructor(private http: HttpClient, private datePipe: DatePipe) { }

  getProducts(page: number): Observable<ProductResponse>{
    return this.http.get<ProductResponse>(`http://localhost:8080/producto/?page=${page}`, {headers});
  }

  getProductId(id: number): Observable<Product>{
    return this.http.get<Product>(`http://localhost:8080/producto/${id}`, {headers})
  }

  postProduct(product: Product, idCategoria: number, ): Observable<Product>{
    return this.http.post<Product>(`http://localhost:8080/usuario/producto/nuevo/${idCategoria}`, product, {headers})
  }

  putProduct(product: Product, id: number): Observable<Product>{
    // const formattedDate = formatDate(product.fechaPublicacion, 'dd-MM-yyyy', 'en-US');
    // product.fechaPublicacion = formattedDate;
    return this.http.put<Product>(`http://localhost:8080/admin/producto/${id}`, product, {headers})
  }

  deleteProduct(id: number): Observable<void>{
    return this.http.delete<void>(`http://localhost:8080/admin/producto/${id}`, {headers})
  }

}
