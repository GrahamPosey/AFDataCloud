import { LightningElement } from 'lwc';
import createGeneration from '@salesforce/apex/CopadoAIPromptLogic.createGeneration';
import companyLogo from '@salesforce/resourceUrl/CopaLogo';

export default class CopadoAIPrompt extends LightningElement {
    prompt = '';
    response = '';
    logoUrl = companyLogo;

    handlePromptChange(event) {
        this.prompt = event.target.value;
    }

    handleClick(event) {
        this.response = 'Working…';
        createGeneration({ prompt: this.prompt })
		.then(result => {
            this.prompt = '';
			this.response = result;
			this.error = undefined;
		})
		.catch(error => {
            this.prompt = '';
            this.response = 'Error';
			this.error = error;
		})
    }
}
