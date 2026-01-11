import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) { }

  getCategories(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/categories`);
  }

  searchBusinesses(query: string, city: string = 'Mumbai'): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/search?query=${query}&city=${city}`);
  }
}
