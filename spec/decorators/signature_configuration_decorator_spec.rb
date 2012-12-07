# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/signature_configuration_decorator'

describe SignatureConfigurationDecorator do
  context '#availables' do
    let :signature_report_enumeration do
      double('SignatureReportEnumeration')
    end

    context 'when do not have current' do
      before do
        component.stub(:report).and_return(nil)

        signature_report_enumeration.stub(:availables).and_return(
          [
            ['Autorizações de Fornecimento', 'supply_authorizations'],
            ['Processos Administrativos', 'administrative_processes']
          ])
      end

      it 'should return all keys' do
        expect(subject.availables(signature_report_enumeration)).to eq [
          ['Autorizações de Fornecimento', 'supply_authorizations'],
          ['Processos Administrativos', 'administrative_processes']
        ]
      end
    end

    context 'when have current' do
      before do
        component.stub(:report).and_return('supply_authorizations')

        signature_report_enumeration.stub(:availables).and_return([
          ['Processos Administrativos', 'administrative_processes']
        ])

        signature_report_enumeration.should_receive(:to_a_by_keys).
          with('supply_authorizations').
          and_return([['Autorizações de Fornecimento', 'supply_authorizations']])
      end

      it 'should return all keys plus current' do
        expect(subject.availables(signature_report_enumeration)).to eq [
          ['Processos Administrativos', 'administrative_processes'],
          ['Autorizações de Fornecimento', 'supply_authorizations']
        ]
      end
    end
  end

  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have report' do
      expect(described_class.header_attributes).to include :report
    end
  end
end
