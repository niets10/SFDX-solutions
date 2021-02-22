import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ToastPlatformEventCmp extends LightningElement {

    channelName = '/event/Toast__e';
    subscription = {};
    
    //Initialize the component
    connectedCallback(){

        const showToastEvent = (response) => {

            //Destructure the response
            const { Title__c, Message__c, Variant__c, Mode__c } = response.data.payload;

            // let toastInfo = response.data.payload;
            const event = new ShowToastEvent({
                title: Title__c,
                message: Message__c,
                variant: Variant__c,
                mode: Mode__c

            });
            this.dispatchEvent(event);
        }

        subscribe(this.channelName, -1, showToastEvent).then(response => {            
            this.subscription = response;            
        });

        onError(error => {
            console.log('Error in Platform Event Toast');
            console.log(error);
        });

    }
}