import {LightningElement, wire} from 'lwc';
import getRatesListForDate from '@salesforce/apex/CurrencyConverterService.getRatesListForDate'


export default class CurrencyConverter extends LightningElement {

    isLoaded = false;
    belRubValue;
    currencyValue;
    currencyValueFrom;
    currencyNameFrom = 'Select currency';
    currencyValueTo;
    currencyNameTo;
    currencyRateFrom;
    currencyRateTo;
    currencyRate;
    currencyScale;
    currencyScaleFrom;
    currencyScaleTo;
    currencyName;
    exchangeRates = [];
    dateRate = new Date(Date.now()).getFullYear() + '-' + (new Date(Date.now()).getMonth() + 1) + '-' + new Date(Date.now()).getDate();

    @wire(getRatesListForDate, {dateRate:'$dateRate'})
    getExchangeRatesList({error, data}) {
        if (data) {
            this.isLoaded = true;
            this.exchangeRates = data;
        } else {
            this.isLoaded = true;
            this.exchangeRates = [{label: 'Warning', value: 'Invalid date'}];
        }
    }

    convertCurrency() {
        this.belRubValue = this.currencyValue * this.currencyRate / this.currencyScale;
    }

    convertAnyToAny(caller) {
        switch (caller) {
            case 'From' :
                this.currencyValueTo = Math.ceil(((this.currencyValueFrom * this.currencyRateFrom / this.currencyScaleFrom) * this.currencyScaleTo / this.currencyRateTo) * 100) / 100;
                break;
            case 'To' :
                this.currencyValueFrom = Math.ceil(((this.currencyValueTo * this.currencyRateTo / this.currencyScaleTo) * this.currencyScaleFrom / this.currencyRateFrom) * 100) / 100;
                break;
        }
    }


    handleDateChange(event) {
        this.belRubValue = null;
        this.currencyValue = null;
        this.currencyValueFrom = null;
        this.currencyNameFrom = null;
        this.currencyValueTo = null;
        this.currencyNameTo = null;
        this.currencyRateFrom = null;
        this.currencyRateTo = null;
        this.currencyRate = null;
        this.currencyScale = null;
        this.currencyScaleFrom = null;
        this.currencyScaleTo = null;
        this.currencyName = null;
        this.isLoaded = false;
        this.dateRate = event.target.value;
    }

    handleCurrencyValueChange(event) {
        switch (event.target.title) {
            case 'Foreign' :
                this.currencyValue = event.target.value;
                break;
            case 'From' :
                this.currencyValueFrom = event.target.value;
                this.convertAnyToAny('From');
                break;
            case 'To' :
                this.currencyValueTo = event.target.value;
                this.convertAnyToAny('To');
                break;
        }

    }

    handleCurrencyChange(event) {
        let currencyName = event.target.options.find(opt => opt.value === event.detail.value).label;
        let currencyScale = event.target.options.find(opt => opt.value === event.detail.value).scale;
        let currencyRate = event.target.value;

        switch (event.target.label) {
            case 'Currency' :
                this.currencyName = currencyName;
                this.currencyRate = currencyRate;
                this.currencyScale = currencyScale;
                this.convertCurrency();
                break;
            case 'From' :
                this.currencyNameFrom = currencyName;
                this.currencyRateFrom = currencyRate;
                this.currencyScaleFrom = currencyScale;
                break;
            case 'To' :
                this.currencyNameTo = currencyName;
                this.currencyRateTo = currencyRate;
                this.currencyScaleTo = currencyScale;
                break;
        }

    }

    get disableInputForeign() {
        return !(this.currencyName)
    }

    get disableInputsAnyToAny() {
        return !(this.currencyNameFrom && this.currencyNameTo)
    }


}