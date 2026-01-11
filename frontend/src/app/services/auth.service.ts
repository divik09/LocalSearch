import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject, tap } from 'rxjs';
import { AuthResponse, LoginRequest, RegisterRequest, User } from '../models/auth.model';

@Injectable({
    providedIn: 'root'
})
export class AuthService {
    private apiUrl = 'http://localhost:8080/api/auth';
    private currentUserSubject = new BehaviorSubject<User | null>(null);
    public currentUser$ = this.currentUserSubject.asObservable();

    constructor(private http: HttpClient) {
        // Load user from localStorage on service initialization
        const token = this.getToken();
        if (token) {
            this.loadCurrentUser();
        }
    }

    register(request: RegisterRequest): Observable<any> {
        return this.http.post(`${this.apiUrl}/register`, request);
    }

    login(request: LoginRequest): Observable<AuthResponse> {
        return this.http.post<AuthResponse>(`${this.apiUrl}/login`, request).pipe(
            tap(response => {
                // Store token and user info
                localStorage.setItem('token', response.token);
                const user: User = {
                    id: response.userId,
                    username: response.username,
                    email: response.email,
                    role: response.role
                };
                localStorage.setItem('user', JSON.stringify(user));
                this.currentUserSubject.next(user);
            })
        );
    }

    logout(): void {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        this.currentUserSubject.next(null);
    }

    getToken(): string | null {
        return localStorage.getItem('token');
    }

    getCurrentUser(): User | null {
        const userStr = localStorage.getItem('user');
        return userStr ? JSON.parse(userStr) : null;
    }

    isAuthenticated(): boolean {
        return !!this.getToken();
    }

    hasRole(role: string): boolean {
        const user = this.getCurrentUser();
        return user?.role === role;
    }

    isSuperAdmin(): boolean {
        return this.hasRole('SUPER_ADMIN');
    }

    isServiceProvider(): boolean {
        return this.hasRole('SERVICE_PROVIDER');
    }

    private loadCurrentUser(): void {
        this.http.get<User>(`${this.apiUrl}/me`).subscribe({
            next: (user) => {
                localStorage.setItem('user', JSON.stringify(user));
                this.currentUserSubject.next(user);
            },
            error: () => {
                // Token might be invalid, logout
                this.logout();
            }
        });
    }

    changePassword(oldPassword: string, newPassword: string): Observable<any> {
        return this.http.put(`${this.apiUrl}/change-password`, { oldPassword, newPassword });
    }
}
