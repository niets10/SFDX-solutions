import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getReports from '@salesforce/apex/ReportsControllerLWC.getReports';
import getFilteredReports from '@salesforce/apex/ReportsControllerLWC.getFilteredReports';
import getRecords from '@salesforce/apex/ReportsControllerLWC.getRecords';

export default class ReportsCmp extends LightningElement {

    //WIRE A FUNCTION
    @wire (getReports) wiredReports({error, data}){
        if(data){
            this.reports = data.sharedRecords;
            this.error = undefined
        }else if(error){
            this.error = error;
            this.reports = undefined;
        }
    }

    //No need to add track property to fields to make them reactive after Spring 20.
    //If fields are use in template or getter
    reports;
    flows;
    showFlowMenu = false;

    //CALL A METHOD IMPERATIVE
    handleChange(event){
        
        var value = event.target.value;
        
        getFilteredReports({ nameFilterString: value })
        .then(results => {

            this.reports = results;
           
        }).catch(error => {

            console.log('Error received: ' + error);

        });

    }

    handleSelect(event){
        var reportDeveloperName = event.detail.name;
        this.showFlowMenu = true;

        getRecords({reportName : reportDeveloperName})
        .then((results) => {

            if(results !== null){
                this.flows = results.flowNames;
            }else{
                this.flows = undefined;
            }
        })
        .catch(error => {
            console.log('Error received: code ' + error);
        })
    }

    //When we have a property we want to return dynamically. In this case, for showing elements conditionally, as this is not supported in HTML markup
    get existentFlows(){

        console.log('Getter execution');

        if(this.flows !== undefined){

            console.log('Length ' + this.flows.length);
        
            if(this.flows.length > 0){
                console.log('True');
                return true;
            }else{
                console.log('False inner');
                return false;
            }
        }else{

            console.log('False outer');

            return false;
        }

    }

}