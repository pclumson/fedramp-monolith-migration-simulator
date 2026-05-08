import { Component } from '@angular/core';

@Component({
  selector: 'app-new-feature',
  template: `
    <div style="padding: 20px; border: 2px solid #007bff; border-radius: 8px; background: #f0f8ff;">
      <h2>🚀 New Micro-Frontend Feature</h2>
      <p>This component is loaded dynamically via <strong>Module Federation</strong>.</p>
      <p><em>Compliance Status: FedRAMP High Ready</em></p>
      <button (click)="alert()">Test Interaction</button>
    </div>
  `,
  styles: []
})
export class NewFeatureComponent {
  alert() {
    alert('Interaction from New Micro-Frontend!');
  }
}
