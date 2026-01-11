import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { FormsModule } from '@angular/forms';

@Component({
    selector: 'app-home',
    standalone: true,
    imports: [CommonModule, RouterModule, FormsModule],
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
    categories: any[] = [];
    searchQuery: string = '';
    cityFilter: string = 'Indore';

    constructor(private apiService: ApiService, private router: Router) { }

    ngOnInit(): void {
        this.apiService.getCategories().subscribe(data => {
            this.categories = data;
        });
    }

    onSearch(): void {
        if (this.searchQuery) {
            this.router.navigate(['/search'], { queryParams: { q: this.searchQuery, city: this.cityFilter } });
        }
    }
}
