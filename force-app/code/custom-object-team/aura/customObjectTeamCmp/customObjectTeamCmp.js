import { LightningElement, wire, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
import { reduceErrors } from "c/reduceErrors";

import getSharedRecords from "@salesforce/apex/CustomObjectTeamController.getSharedRecords";
import insertSharing from "@salesforce/apex/CustomObjectTeamController.insertSharing";
import deleteSharedRecord from "@salesforce/apex/CustomObjectTeamController.deleteSharedRecord";

//Import custom lookup
import search from "@salesforce/apex/SampleLookupController.search";
import getRecentlyViewed from "@salesforce/apex/SampleLookupController.getRecentlyViewed";

//Const declaration for datatable
const actions = [{ label: "Delete", name: "delete" }];

const columns = [
  {
    label: "Team Member",
    fieldName: "UserName",
    type: "name",
    sortable: false,
    cellAttributes: { iconName: "standard:user", iconPosition: "left", class: "slds-border_right"}
  },
  {
    label: "Member Role",
    fieldName: "RowCause",
    type: "string",
    sortable: false
  },
  {
    label: "Access Level",
    fieldName: "AccessLevel",
    type: "string",
    sortable: false
  },
  {
    type: "action",
    typeAttributes: {
      rowActions: actions,
      menuAlignment: "right"
    }
  }
];

export default class CustomObjectTeamCmp extends LightningElement {
  columns = columns;
  objects = ["One", "Two", "Three"];
  records;
  refreshTable;
  //Boolean to decide if we show the table or not
  showTable = false;
  isOpenModal = false;
  isOpenModalDelete = false;

  //Store the clicked row of the ligthning table
  clickedRow;
  userId;
  error;
  accessLevelValue = "read";
  //Show Object Label
  objectLabel;

  //RecordId
  @api recordId;
  
  //Design attributes
  @api rowCauseName;
  @api rowCauseLabel;
  

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////// ON INIT /////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////


  //Wiring a function returns a provisioned value that we can destructure in error and data.
  //If we want to use refresh apex, we need to get the provisioned value as that's the one we need to refresh
  @wire(getSharedRecords, { recordId: "$recordId", rowCauseName : "$rowCauseName" }) wiredRecords(result) {
    // Hold on to the provisioned value so we can refresh it later.
    this.refreshTable = result;

    //Destructure the provisioned value. Not used
    const { data, error } = result;

    if (result.data) {
      this.refreshTable = result;
      this.objectLabel = result.data.objectLabel;
      //Hack to show UserOrGroup.Name in datatable
      this.records = result.data.sharedRecords.map((row) => {
        return { ...row, UserName: row.UserOrGroup.Name, RowCause: this.rowCauseLabel };
      });      
      
      if(result.data.sharedRecords.length > 0){
        this.showTable = true;
      }else{
        this.showTable = false;
      }

      this.error = undefined;
    } else if (result.error) {
      console.log("Error: " + result.error);
    }
  }

  get cardTitle() {
    return this.objectLabel + ' Team';
  }

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////// Modal NEW ///////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////
  get picklistOptions() {
    return [
      { label: "Read", value: "read" },
      { label: "Read/Write", value: "readWrite" }
    ];
  }

  //Insert Sharing
  createNewSharing() {
    //Call APEX method
    insertSharing({
      parentId: this.recordId,
      userId: this.userId,
      accessLevel: this.accessLevelValue
    })
      .then(() => {
        this.handleSuccess();
      })
      .catch((error) => {
        this.handleCloseModal();

        this.dispatchEvent(
          new ShowToastEvent({
            message:
              "There was an error when inserting the Team Member: " +
              reduceErrors(error),
            variant: "error"
          })
        );
      });
  }

  //Handle success for sharing insertion
  handleSuccess() {
    this.handleCloseModal();

    this.dispatchEvent(
      new ShowToastEvent({
        message: "Team Member inserted sucessfully",
        variant: "success"
      })
    );

    return refreshApex(this.refreshTable);
  }

  //Open Modal
  handleOpenModal() {
    this.isOpenModal = true;
  }

  //Close Modal
  handleCloseModal() {
    this.isOpenModal = false;
  }

  handlePicklistSelection(event) {
    this.accessLevelValue = event.detail.value;
  }

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////// Modal DELETE ////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////
  handleOpenModalDelete() {
    this.isOpenModalDelete = true;
  }
  handleCloseModalDelete() {
    this.isOpenModalDelete = false;
  }

  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////// Lightning Table /////////////////////////
  ///////////////////////////////////////////////////////////////////////////

  //Row actions in lightning table
  handleRowActions(event) {
    let actionName = event.detail.action.name;
    let row = event.detail.row;
    console.log("RowId " + JSON.stringify(row));
    // eslint-disable-next-line default-case
    switch (actionName) {
      case "delete":
        this.clickedRow = row;
        this.handleOpenModalDelete();
        break;
    }
  }

  //To delete the selected relations
  deleteRelations() {
    //this.showLoadingSpinner = true;

    var currentRow = this.clickedRow;
    //Calling apex class method to delete the selected contact
    deleteSharedRecord({ recordId: currentRow.Id })
      .then((result) => {
        //this.showLoadingSpinner = false;
        console.log("Result" + JSON.stringify(result));
        // showing success message
        this.dispatchEvent(
          new ShowToastEvent({
            message: "Team Member deleted sucessfully",
            variant: "success"
          })
        );

        // refreshing table data using refresh apex
        this.handleCloseModalDelete();
        return refreshApex(this.refreshTable);
        
      })
      .catch((error) => {
        console.log("Error body:" + JSON.stringify(error.body));
        this.dispatchEvent(
          new ShowToastEvent({
            message:
              "There was an error when deleting the Team Member: " +
              reduceErrors(error),
            variant: "error"
          })
        );

        this.handleCloseModalDelete();
      });
      
  }

  /////////////////////////////////////////////////////////////////////////
  /////////////////////////// Custom lookup LWC ///////////////////////////
  /////////////////////////////////////////////////////////////////////////
  @api notifyViaAlerts = false;

  isMultiEntry = false;
  maxSelectionSize = 2;
  initialSelection = [];
  errors = [];
  recentlyViewed = [];

  /**
   * Loads recently viewed records and set them as default lookpup search results (optional)
   */
  @wire(getRecentlyViewed)
  getRecentlyViewed({ data }) {
    if (data) {
      this.recentlyViewed = data;
      this.initLookupDefaultResults();
    }
  }

  connectedCallback() {
    this.initLookupDefaultResults();
  }

  /**
   * Initializes the lookup default results with a list of recently viewed records (optional)
   */
  initLookupDefaultResults() {
    // Make sure that the lookup is present and if so, set its default results
    const lookup = this.template.querySelector("c-lookup");
    if (lookup) {
      lookup.setDefaultResults(this.recentlyViewed);
    }
  }

  /**
   * Handles the lookup search event.
   * Calls the server to perform the search and returns the resuls to the lookup.
   * @param {event} event `search` event emmitted by the lookup
   */
  handleLookupSearch(event) {
    // Call Apex endpoint to search for records and pass results to the lookup
    search(event.detail)
      .then((results) => {
        this.template.querySelector("c-lookup").setSearchResults(results);
      })
      .catch((error) => {
        this.notifyUser(
          "Lookup Error",
          "An error occured while searching with the lookup field.",
          "error"
        );
        // eslint-disable-next-line no-console
        console.error("Lookup error", JSON.stringify(error));
        this.errors = [error];
      });
  }

  /**
   * Handles the lookup selection change
   * @param {event} event `selectionchange` event emmitted by the lookup.
   * The event contains the list of selected ids.
   */
  // eslint-disable-next-line no-unused-vars
  handleLookupSelectionChange(event) {
    this.checkForErrors();
  }

  // All functions below are part of the sample app form (not required by the lookup).

  handleLookupTypeChange(event) {
    this.initialSelection = [];
    this.errors = [];
    this.isMultiEntry = event.target.checked;
  }

  handleMaxSelectionSizeChange(event) {
    this.maxSelectionSize = event.target.value;
  }

  handleSubmit() {
    this.checkForErrors();
    if (this.errors.length === 0) {
      this.notifyUser("Success", "The form was submitted.", "success");
    }
  }

  handleClear() {
    this.initialSelection = [];
    this.errors = [];
  }

  checkForErrors() {
    this.errors = [];
    const selection = this.template.querySelector("c-lookup").getSelection();
    // Custom validation rule
    if (this.isMultiEntry && selection.length > this.maxSelectionSize) {
      this.errors.push({
        message: `You may only select up to ${this.maxSelectionSize} items.`
      });
    }
    // Enforcing required field
    if (selection.length === 0) {
      this.errors.push({ message: "Please make a selection." });
    } else {
      //Get UserId from selection
      //The component is designed to handle several users, but in this case we will only have a record
      this.userId = selection[0].id;
    }
  }

  notifyUser(title, message, variant) {
    if (this.notifyViaAlerts) {
      // Notify via alert
      // eslint-disable-next-line no-alert
      alert(`${title}\n${message}`);
    } else {
      // Notify via toast (only works in LEX)
      const toastEvent = new ShowToastEvent({ title, message, variant });
      this.dispatchEvent(toastEvent);
    }
  }
}