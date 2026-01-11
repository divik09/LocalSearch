export interface User {
    id: number;
    username: string;
    email: string;
    role: 'SUPER_ADMIN' | 'SERVICE_PROVIDER';
}

export interface AuthResponse {
    token: string;
    userId: number;
    username: string;
    email: string;
    role: 'SUPER_ADMIN' | 'SERVICE_PROVIDER';
}

export interface RegisterRequest {
    username: string;
    email: string;
    password: string;
    role?: 'SUPER_ADMIN' | 'SERVICE_PROVIDER';
}

export interface LoginRequest {
    username: string;
    password: string;
}
