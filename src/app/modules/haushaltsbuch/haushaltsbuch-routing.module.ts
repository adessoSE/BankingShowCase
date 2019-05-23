import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HaushaltsbuchComponent } from 'src/app/components/haushaltsbuch/haushaltsbuch.component';

const routes: Routes = [
  {path: 'haushaltsbuch/credit-scoring', component: HaushaltsbuchComponent}
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class HaushaltsbuchRoutingModule { }
