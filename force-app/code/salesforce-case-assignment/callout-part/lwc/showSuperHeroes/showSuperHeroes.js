import { LightningElement } from 'lwc';
import fetchHeroes from '@salesforce/apex/SuperHeroesCallout.fetchHeroes';

const columns = [
    { label: 'Name', fieldName: 'name' },
    { label: 'Alias', fieldName: 'alias' },
    { label: 'Superpower', fieldName: 'superpower' }
];

export default class ShowSuperHeroes extends LightningElement {

    error;
    heroes;
    columns = columns;
    isLoading = false;
    
    fetchDataApex() {
        console.log('Performing callout');

        this.isLoading = true;

        fetchHeroes()
            .then( ( result ) => {
                console.log('Result ' + JSON.stringify(result));

                // this.heroes.push(result[0]);
                this.heroes = result;
                this.isLoading = false;

                console.log('Heroes ' + JSON.stringify(this.heroes));

            })
            .catch( (error) => {
                console.log('Error: ' + JSON.stringify(error));
                this.error = JSON.stringify(error);
                this.isLoading = false;
            })
    }

}