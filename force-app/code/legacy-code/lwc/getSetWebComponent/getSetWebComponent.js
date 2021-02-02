import { LightningElement, track } from 'lwc';

export default class GetSetWebComponent extends LightningElement {
    efaultMsg = "We are learning ";
    @track outputMessage;
 
       
    get messages(){
        return this.defaultMsg + "Lightning Web Component";
         
    }
 
    set mensajeset(val){
       this.outputMessage = val;
    }
 
    handleMessage(event){
        this.mensajeset = event.target.value;
    }
}