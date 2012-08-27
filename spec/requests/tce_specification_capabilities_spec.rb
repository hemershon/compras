# encoding: utf-8
require 'spec_helper'

feature "TceSpecificationCapabilities" do
  background do
    sign_in
  end

  scenario 'create a new tce_specification_capability' do
    CapabilitySource.make!(:imposto)
    ApplicationCode.make!(:geral)

    navigate 'Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Criar Especificação de Recursos do TCE'

    within_tab 'Principal' do
      fill_in 'Descrição', :with => 'Ampliação do Posto de Saúde'
      fill_modal 'Fonte de recursos', :with => 'Imposto'
      fill_modal 'Código da aplicação', :with => 'Geral'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Especificação de Recursos do TCE criado com sucesso.'

    click_link 'Ampliação do Posto de Saúde'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => TceSpecificationCapability.last.id.to_s
      expect(page).to have_field 'Descrição', :with => 'Ampliação do Posto de Saúde'
      expect(page).to have_field 'Fonte de recursos', :with => 'Imposto'
      expect(page).to have_field 'Especificação da fonte de recursos', :with => 'Especificação'
      expect(page).to have_field 'Código da aplicação', :with => 'Geral'
      expect(page).to have_field 'Especificação do código da aplicação', :with => 'Recursos próprios da entidade de livre aplicação'
    end
  end

  scenario 'update an existent tce_specification_capability' do
    CapabilitySource.make!(:transferencia)
    ApplicationCode.make!(:transito)
    TceSpecificationCapability.make!(:ampliacao)

    navigate 'Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Ampliação do Posto de Saúde'

    within_tab 'Principal' do
      fill_in 'Descrição *', :with => 'Reforma do Posto de Saúde'
      fill_modal 'Fonte de recursos', :with => 'Transferência'
      fill_modal 'Código da aplicação', :with => 'Trânsito'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Especificação de Recursos do TCE editado com sucesso.'

    click_link 'Reforma do Posto de Saúde'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => TceSpecificationCapability.last.id.to_s
      expect(page).to have_field 'Descrição *', :with => 'Reforma do Posto de Saúde'
      expect(page).to have_field 'Fonte de recursos', :with => 'Transferência'
      expect(page).to have_field 'Especificação da fonte de recursos', :with => 'Entre convênios'
      expect(page).to have_field 'Código da aplicação', :with => 'Trânsito'
      expect(page).to have_field 'Especificação do código da aplicação', :with => 'Recursos vinculados ao Trânsito'
    end
  end

  scenario 'destroy an existent tce_specification_capability' do
    TceSpecificationCapability.make!(:ampliacao)

    navigate 'Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Ampliação do Posto de Saúde'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Especificação de Recursos do TCE apagado com sucesso.'

    expect(page).to_not have_content 'Ampliação do Posto de Saúde'
  end
end