import { LightningElement, track } from 'lwc';
import consultarCPF from '@salesforce/apex/CPFHubController.buscarCPF';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CpfConsultation
extends LightningElement {

    cpf = '';
    @track dados;
    loading = false;

    handleCpfChange(event) {

        let value = event.target.value;

        value = value.replace(/\D/g, '');
        
        value = value.replace(/(\d{3})(\d)/, '$1.$2');

        value = value.replace(/(\d{3})(\d)/, '$1.$2');

        value = value.replace(/(\d{3})(\d{1,2})$/, '$1-$2');

        this.cpf = value;
    }

    async consultar() {

        this.loading = true;
        this.dados = null;

        try {
            const response = await consultarCPF({cpf: this.cpf});

            this.dados = response.data;

            this.showToast(
                'Sucesso',
                'CPF consultado com sucesso.',
                'success'
            );

        } catch(error) {

            let mensagem = 'Erro ao consultar CPF.';

            if(error && error.body && error.body.message) {
                mensagem = error.body.message;
            }

            this.showToast(
                'Erro',
                mensagem,
                'error'
            );
        }

        finally {
            this.loading = false;
        }
    }

    showToast(title, message, variant) {

        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }

    /* Método ainda não utilizado, mas que no futuro possar utilizado*/
    get cpfMascarado() {

        if(!this.dados?.cpf) {
            return '';
        }

        return this.dados.cpf.replace(/(\d{3})\d{6}(\d{2})/, '$1.***.***-$2');
    }
}