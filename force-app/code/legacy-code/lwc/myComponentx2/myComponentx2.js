import { LightningElement, api, track } from 'lwc';

export default class MyComponentx2 extends LightningElement {
    @track privateTitle;

    @api
    get title() {
        return this.privateTitle;
    }

    set title(value) {
        this.privateTitle = value.toUpperCase();
        //this.setAttribute('title', this.privateTitle);
    }
}