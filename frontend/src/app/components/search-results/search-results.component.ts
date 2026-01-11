import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { ApiService } from '../../services/api.service';

@Component({
    selector: 'app-search-results',
    standalone: true,
    imports: [CommonModule],
    templateUrl: './search-results.component.html',
    styleUrls: ['./search-results.component.css']
})
export class SearchResultsComponent implements OnInit {
    businesses: any[] = [];
    query: string = '';

    constructor(
        private route: ActivatedRoute,
        private apiService: ApiService,
        private cdr: ChangeDetectorRef
    ) { }

    ngOnInit(): void {
        this.route.queryParams.subscribe(params => {
            this.query = params['q'] || '';
            console.log('Search query:', this.query);
            this.search();
        });
    }

    search(): void {
        this.apiService.searchBusinesses(this.query).subscribe(data => {
            console.log('Received businesses:', data);
            this.businesses = data;
            console.log('Businesses array length:', this.businesses.length);
            this.cdr.detectChanges(); // Force change detection
        });
    }
}
