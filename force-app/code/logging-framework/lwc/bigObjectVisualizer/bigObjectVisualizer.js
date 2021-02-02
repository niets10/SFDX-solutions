import { LightningElement, wire } from "lwc";
import getLogRecords from "@salesforce/apex/BigObjectController.getLogRecords";

//Datatable columns declaration
const columns = [
    {
      label: "Created Date",
      fieldName: "CreatedDate",
      type: "datetime",

    },
    {
      label: "Request Id",
      fieldName: "RequestId__c",
      type: "string",
    },
    {
      label: "Log Message",
      fieldName: "LogMessage__c",
      type: "string",
    }
];
  
export default class BigObjectVisualizer extends LightningElement {

    columns = columns;
    showTable = true;
    records;

    @wire(getLogRecords) wiredRecords(result) {

        console.log(JSON.stringify(result));

        if (result.data) {

            this.records = result.data;
                   
        }else if(result.error){
            console.log("Error: " + result.error);
        }

    }

}