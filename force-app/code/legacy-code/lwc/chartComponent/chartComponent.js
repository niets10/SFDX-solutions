import { LightningElement, api } from 'lwc';

export default class ChartComponent extends LightningElement {

    @api percentage;

    get style() {

        return `width: ${this.percentage}%`;

    }

}