import { NgModule } from "@angular/core";
import { HaushaltsbuchRoutingModule } from './haushaltsbuch-routing.module';
import { HaushaltsbuchComponent } from '../../components/haushaltsbuch/haushaltsbuch.component';
import { MaterialModule } from '../Material/material.module';
import { CreditScoringComponent } from 'src/app/components/haushaltsbuch/credit-scoring/credit-scoring.component';
import { PaymentDataService } from 'src/app/services/payment-data.service';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    HaushaltsbuchComponent,
    CreditScoringComponent
  ],
  imports: [
    HaushaltsbuchRoutingModule,
    MaterialModule,
    BrowserModule,
    FormsModule,
    ReactiveFormsModule
  ],
  exports: [
    HaushaltsbuchComponent,
    CreditScoringComponent
  ],
  providers: [
    PaymentDataService
  ],
  bootstrap: [
    HaushaltsbuchComponent,
    CreditScoringComponent
  ]
})
export class HaushaltsbuchModule {
}