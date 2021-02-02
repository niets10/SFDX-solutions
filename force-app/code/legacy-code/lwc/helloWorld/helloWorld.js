import { LightningElement, track, api } from 'lwc';

export default class HelloWorld extends LightningElement {

    @api publicProperty = 'Kulo';    
    @api name = 'Álvaro';
    @track surname = 'Nieto';
    @track firstName = 'Pedro';
    @track age = 25;
    una = 222;
    
    //Example of a getter
    get multiplicado() {
        var numero = this.una * 5;
        return numero;

    }

    //Property (first way)
    handleChange(ev) {
        this.name = ev.target.value;
    }

    //Getter (second way)
    handleChange1(ev) {
        this.surname = ev.target.value;
    }

    get apellidoGetter() {
        return this.surname;
    }

    //QuerySelector (third way)
    handleChange2() {
        this.firstName = this.template.querySelector("[data-id='input1']").value;
    }

    //QueryAll (fourth way)
    handleChange3() {

        var listInput = this.template.querySelectorAll("lightning-input");

        listInput.forEach(function(e){

            if(e.name === 'edadInput'){
                this.age = e.value;
            }

        }, this);

    }

}