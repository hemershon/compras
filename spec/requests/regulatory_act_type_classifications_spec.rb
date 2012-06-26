# encoding: utf-8
require 'spec_helper'

feature "RegulatoryActTypeClassifications" do
  background do
    sign_in
  end

  scenario 'create a new regulatory_act_type_classification' do
    navigate_through 'Contabilidade > Comum > Legislação > Ato Regulamentador > Classificações de Tipo de Ato Regulamentador'

    click_link 'Criar Classificação de Tipos de Ato Regulamentador'

    fill_in 'Descrição', :with => 'description'

    click_button 'Salvar'

    page.should have_notice 'Classificação de Tipos de Ato Regulamentador criado com sucesso.'

    click_link 'description'

    page.should have_field 'Descrição', :with => 'description'
  end

  scenario 'validates uniqueness of description' do
    RegulatoryActTypeClassification.make!(:primeiro_tipo)

    navigate_through 'Contabilidade > Comum > Legislação > Ato Regulamentador > Classificações de Tipo de Ato Regulamentador'

    click_link 'Criar Classificação de Tipos de Ato Regulamentador'

    fill_in 'Descrição', :with => 'Tipo 01'

    click_button 'Salvar'

    page.should_not have_notice 'Classificação Tipos de Ato Regulamentador criado com sucesso.'

    page.should have_content 'já está em uso'
  end

  scenario 'update an existent regulatory_act_type_classification' do
    RegulatoryActTypeClassification.make!(:primeiro_tipo)

    navigate_through 'Contabilidade > Comum > Legislação > Ato Regulamentador > Classificações de Tipo de Ato Regulamentador'

    click_link 'Tipo 01'

    fill_in 'Descrição', :with => 'Segundo Tipo'

    click_button 'Salvar'

    page.should have_notice 'Classificação de Tipos de Ato Regulamentador editado com sucesso.'

    click_link 'Segundo Tipo'

    page.should have_field 'Descrição', :with => 'Segundo Tipo'
  end

  scenario 'destroy an existent regulatory_act_type_classification' do
    RegulatoryActTypeClassification.make!(:primeiro_tipo)

    navigate_through 'Contabilidade > Comum > Legislação > Ato Regulamentador > Classificações de Tipo de Ato Regulamentador'

    click_link 'Tipo 01'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Classificação de Tipos de Ato Regulamentador apagado com sucesso.'

    page.should_not have_content 'description'
  end
end
