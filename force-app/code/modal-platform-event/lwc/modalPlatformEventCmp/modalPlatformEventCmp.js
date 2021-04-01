import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';

class Contact {
    constructor(name, email){
        this.name = name;
        this.email = email;
    }
}
export default class ModalPlatformEventCmp extends LightningElement {
    isOpenModal = false;
    channelName = '/event/Modal__e';
    subscription = {};
    contacts = [];

    handleCloseModal () {
        this.isOpenModal = false;
        // unsubscribe(this.subscription, response => {
        //     console.log('unsubscribe() response: ', JSON.stringify(response));
        //     // Response is true for successful unsubscribe
        // });
    }

    connectedCallback(){

        const openModal = (response) => {
            this.isOpenModal = true;

            // console.log('Payload ' + response.data.payload);
            //Destructure the response
            const { ContactName__c, ContactEmail__c } = response.data.payload;

            let contact = new Contact(ContactName__c, ContactEmail__c);
            this.contacts.push(contact);
            console.log('Response ' + JSON.stringify(this.contacts));
        }

        subscribe(this.channelName, -1, openModal).then(response => {            
            this.subscription = response;            
        });

        onError(error => {
            console.log('Error in Platform Event Toast');
            console.log(error);
        });

    }

}