import { LightningElement, track } from 'lwc';

export default class TrackObject extends LightningElement {

    @track x = {

        a : "",
        b : ""
    }

    init() {
        this.x.a = "A al iniciar";
        this.x.b = "B al iniciar";
    }

    update() {
        this.x.a = "A al actualizar";
        this.x.b = "B al actualizar";
    }

}