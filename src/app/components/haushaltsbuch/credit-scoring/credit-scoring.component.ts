import { Component, OnInit } from '@angular/core';
import { PaymentDataService } from 'src/app/services/payment-data.service';
import { FormGroup, FormControl } from '@angular/forms';
import { PaymentData } from '../../../models/payment-data';
import { MatSnackBar } from '@angular/material';

@Component({
  selector: 'credit-scoring',
  templateUrl: './credit-scoring.component.html',
  styleUrls: ['./credit-scoring.component.scss']
})
export class CreditScoringComponent implements OnInit {

  saveForm: FormGroup = new FormGroup(
    {
      name: new FormControl(''),
      betrag: new FormControl(''),
      zahlungstyp: new FormControl(''),
      date: new FormControl('')
    }
  );

  isLoading: boolean = false;

  constructor(
    private paymentDataService: PaymentDataService,
    private snackBar: MatSnackBar
  ) { }

  ngOnInit(): void { }

  resetForm() {
    this.saveForm.reset();
  }

  savePaymentData() {
    this.isLoading = true;
    let date: Date = new Date(this.saveForm.get("date").value);
    let dateD = date.getDate().toString() + "/" + date.getMonth().toString() + "/" + date.getFullYear().toString();
    let datetime = date.getTime().toString();
    let timestamp = date.getFullYear().toString() + "-" + date.getMonth().toString() + "-" + date.getDate().toString() + " 00:00:00";
    let data: PaymentData = {
      step: 1,
      action: this.saveForm.get("zahlungstyp").value,
      amount: this.saveForm.get("betrag").value,
      amount_real: this.saveForm.get("betrag").value,
      nameOrig: this.saveForm.get("name").value,
      place: "Nowhere",
      date: dateD,
      datetime: datetime,
      verwendungszweck: "Verwendungszweck",
      oldBalanceOrig: 1.0,
      newBalanceOrig: 2.0,
      nameDest: "Harry Potter (563920746)",
      oldBalanceDest: 1.2,
      newBalanceDest: 2.2,
      isFraud: 0,
      isFlaggedFraud: 0,
      isUnauthorizedOverdraft: 0,
      datetime_timestamp: timestamp
    }
    this.paymentDataService.savePaymentData(data).subscribe((res: any) => {
      setTimeout(() => {
        this.isLoading = false;
        this.openSnackbar(res.data.message);
      }, 2500);
    }, (err) => {
      this.isLoading = false;
      this.openSnackbar(err.error.message);
    });
  }

  openSnackbar(message) {
    this.snackBar.open(message, "Okay", {
      duration: 2000,
    });
  }
}
