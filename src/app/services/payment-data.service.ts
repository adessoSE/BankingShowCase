import { Injectable } from '@angular/core';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { PaymentData } from '../models/payment-data';

@Injectable({
    providedIn: 'root'
})
export class PaymentDataService {

    private url: string = "http://localhost:3000/payment-data";
    private httpOptions: HttpHeaders;

    constructor(private http: HttpClient) { }

    savePaymentData(data: PaymentData) {
        console.log("Payment data")
        console.log(data);
        return this.http.post(this.url,{payment_data: data});
    }

    loadUserData(): Promise<any> {
        return this.http
            .get('http://localhost:3000/users').toPromise()
            .then( (response) => {
                return response;
            })
            .catch( (error) => {
                console.log(error);
            });
    }
}