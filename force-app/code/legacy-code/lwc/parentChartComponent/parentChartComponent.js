import { LightningElement, track } from 'lwc';

export default class ParentChartComponent extends LightningElement {

    @track porcentaje = 50;

    handlePercentageChange(event) {

        this.porcentaje = event.target.value;

    }

}