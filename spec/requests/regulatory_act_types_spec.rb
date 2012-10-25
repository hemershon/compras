# encoding: utf-8
require 'spec_helper'

feature "RegulatoryActTypes" do
  background do
    sign_in
  end

  scenario 'create a new regulatory_act_type' do
    RegulatoryActTypeClassification.make!(:primeiro_tipo)

    navigate 'Cadastros Gerais > Legislação > Ato Regulamentador > Tipos de Ato Regulamentador'

    click_link 'Criar Tipo de Ato Regulamentador'

    fill_modal 'Classificação do tipo de ato regulamentador', :with => 'Tipo 01', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Lei'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Ato Regulamentador criado com sucesso.'

    click_link 'Lei'

    expect(page).to have_field 'Classificação do tipo de ato regulamentador', :with => 'Tipo 01'
    expect(page).to have_field 'Descrição', :with => 'Lei'
  end

  scenario 'update an existent regulatory_act_type' do
    RegulatoryActType.make!(:lei)
    RegulatoryActTypeClassification.make!(:segundo_tipo)

    navigate 'Cadastros Gerais > Legislação > Ato Regulamentador > Tipos de Ato Regulamentador'

    click_link 'Lei'

    fill_modal 'Classificação do tipo de ato regulamentador', :with => 'Tipo 02', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Outra Lei'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Ato Regulamentador editado com sucesso.'

    click_link 'Outra Lei'

    expect(page).to have_field 'Classificação do tipo de ato regulamentador', :with => 'Tipo 02'
    expect(page).to have_field 'Descrição', :with => 'Outra Lei'
  end

  scenario 'destroy an existent regulatory_act_type' do
    RegulatoryActType.make!(:lei)

    navigate 'Cadastros Gerais > Legislação > Ato Regulamentador > Tipos de Ato Regulamentador'

    click_link 'Lei'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Ato Regulamentador apagado com sucesso.'

    expect(page).to_not have_content 'Lei'
  end
end
