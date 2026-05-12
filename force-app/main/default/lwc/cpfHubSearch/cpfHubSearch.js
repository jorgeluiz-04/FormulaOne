import { LightningElement, track } from 'lwc';
import checkCPF from '@salesforce/apex/CPFHubController.searchCPF';
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

    async checkingCPF() {
        const cpfLimpo = this.cpf.replace(/\D/g, '');

        if (cpfLimpo.length !== 11) {
            this.showToast(
                'Erro',
                'Informe um CPF válido.',
                'error'
            );

            return;
        }

        this.loading = true;
        this.dados = null;

        try {
            const response = await checkCPF({cpf: this.cpf});

            this.dados = response.data;

            this.cpf = '';
            
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

    get cpfMask() {
        const cpf = this.dados?.cpf;

        if (!cpf) {
            return '';
        }

        const cpfLimpo = cpf.replace(/\D/g, '');

        if (cpfLimpo.length !== 11) {
            return '';
        }

        return cpfLimpo.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/,'$1.***.***-$4');
    }

    get genderFormatted() {
        const genero = this.dados?.gender?.toUpperCase();

        if(!genero) {
            return '';
        }

        if(genero === 'M') {
            return 'Masculino';
        }

        if(genero === 'F') {
            return 'Feminino';
        }

        return genero;
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
}