import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Venta } from '../interfaces/venta';
import { HttpClient, HttpHeaders } from '@angular/common/http';

const TOKEN = window.sessionStorage.getItem('auth-token');
const headers = new HttpHeaders({
  'Authorization': `Bearer ${TOKEN}`
}).append('Content-Type', 'application/json');


@Injectable({
  providedIn: 'root'
})
export class VentaService {

  constructor(private http: HttpClient){

  }
  
  getHistorico(): Observable<Venta[]>{
    return this.http.get<Venta[]>(`http://localhost:8080/admin/historico/`, {headers});
  }
  
}
