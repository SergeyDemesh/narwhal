import { LightningElement } from 'lwc';

export default class Clock extends LightningElement {
    timestamp = new Date();

    connectedCallback() {
        setInterval(() => {
            this.timestamp = new Date();
        } ,1000);

    }
}