import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { RegisterRequest } from '../../models/auth.model';

@Component({
    selector: 'app-register',
    standalone: true,
    imports: [CommonModule, FormsModule, RouterModule],
    templateUrl: './register.component.html',
    styleUrls: ['./register.component.css']
})
export class RegisterComponent {
    registerData: RegisterRequest = {
        username: '',
        email: '',
        password: '',
        role: 'SERVICE_PROVIDER'
    };

    confirmPassword = '';
    errorMessage = '';
    successMessage = '';
    isLoading = false;

    constructor(
        private authService: AuthService,
        private router: Router
    ) { }

    onSubmit(): void {
        this.errorMessage = '';
        this.successMessage = '';

        // Validation
        if (!this.registerData.username || !this.registerData.email || !this.registerData.password) {
            this.errorMessage = 'Please fill in all fields';
            return;
        }

        if (this.registerData.password.length < 6) {
            this.errorMessage = 'Password must be at least 6 characters';
            return;
        }

        if (this.registerData.password !== this.confirmPassword) {
            this.errorMessage = 'Passwords do not match';
            return;
        }

        this.isLoading = true;

        this.authService.register(this.registerData).subscribe({
            next: (response) => {
                console.log('Registration successful', response);
                this.successMessage = 'Registration successful! Redirecting to login...';
                setTimeout(() => {
                    this.router.navigate(['/login']);
                }, 2000);
            },
            error: (error) => {
                console.error('Registration error', error);
                this.errorMessage = error.error?.message || 'Registration failed. Please try again.';
                this.isLoading = false;
            }
        });
    }
}
