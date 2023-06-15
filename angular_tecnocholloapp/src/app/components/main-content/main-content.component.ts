import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-main-content',
  template: `
    <app-menu></app-menu>
    <!-- <router-outlet></router-outlet> -->
  `,
  styles: []
})
export class MainContentComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

}
