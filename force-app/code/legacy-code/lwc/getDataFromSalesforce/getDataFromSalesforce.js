import { LightningElement, wire, track } from 'lwc';
import methodDone from '@salesforce/apex/LWCController.getContactList';

const DELAY = 300;

export default class GetDataFromSalesforce extends LightningElement {
    
    @track searchKey = '';

    @wire(methodDone, { searchKey: '$searchKey' })
    contacts;

    handleKeyChange(event) {
        // Debouncing this method: Do not update the reactive property as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }

}