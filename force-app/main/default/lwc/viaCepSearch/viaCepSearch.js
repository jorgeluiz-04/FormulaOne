import { LightningElement, api, track } from 'lwc';
import consultaCep from '@salesforce/apex/CepServiceController.consultaCep';
import atualizarEnderecoConta from '@salesforce/apex/CepServiceController.atualizarEnderecoConta';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/refresh';
import { NavigationMixin } from 'lightning/navigation';

export default class ViaCepSearch extends LightningElement {
    @api recordId;
    cep = '';
    numero = '';
    endereco = {};
    erro;

    handleCepChange(event) {
        this.cep = event.detail.value;
    }

    handleNumberChange(event) {
        this.numero = event.detail.value;
    }

    handleSearchCep() {
        this.erro = null;
        //this.endereco = null;
    
        const cepLimpo = this.cep.replace(/\D/g, '');
    
        if (!cepLimpo || cepLimpo.length !== 8) {
            this.erro = 'CEP inválido. Deve conter 8 números.';
            const evt = new ShowToastEvent({
                title: 'Erro!',
                message: this.erro,
                variant: 'info',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            return;
        }
    
        consultaCep({ cepDigitado: cepLimpo })
            .then(result => {   
                this.endereco = result;
                console.log('Retorno Apex: ', result);
                const evt = new ShowToastEvent({
                    title: 'Sucesso!',
                    message: 'Consulta realizada com sucesso!',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                console.log('Retorno ViaCEP: ', JSON.stringify(this.endereco));
            })
            .catch(error => {
                this.erro = error.body ? error.body.message : 'Erro ao buscar o CEP.';
                const evt = new ShowToastEvent({
                    title: 'Erro!',
                    message: 'Erro ao realizar a consulta!',
                    variant: 'error',
                    mode: 'sticky'
                });
                this.dispatchEvent(evt);
                console.log('Erro ViaCEP: ', JSON.stringify(this.erro));
            });
    }    

    handleSave() {
        if (!this.endereco || !this.recordId) {
            this.erro = 'Dados incompletos para salvar.';
            return;
        }

        if (!this.numero) {
            this.erro = 'Informe o número do endereço.';
            return;
        }

        atualizarEnderecoConta({
            contaId: this.recordId,
            enderecoJson: JSON.stringify(this.endereco),
            numero: this.numero
        })
        .then(() => {
            const evt = new ShowToastEvent({
                title: 'Sucesso!',
                message: 'Endereço atualizado com sucesso!',
                variant: 'success'
            });
            this.dispatchEvent(evt);
            window.location.href = '/' + this.recordId;
            /*this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: 'Account',
                    actionName: 'view'
                }
            });*/
        })
        .catch(error => {
            this.erro = error.body ? error.body.message : 'Erro ao salvar o endereço.';
            const evt = new ShowToastEvent({
                title: 'Erro!',
                message: this.erro,
                variant: 'error',
                mode: 'sticky'
            });
            this.dispatchEvent(evt);
        });
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    
}