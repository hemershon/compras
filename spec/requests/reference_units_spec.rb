# encoding: utf-8
require 'spec_helper'

feature "ReferenceUnits" do
  background do
    sign_in
  end

  scenario 'create a new reference_unit' do
    click_link 'Cadastros Diversos'

    click_link 'Unidades de Referência'

    click_link 'Criar Unidade de Referência'

    fill_in 'Nome', :with => 'Reais'
    fill_in 'Sigla', :with => 'R$'

    click_button 'Criar Unidade de Referência'

    page.should have_notice 'Unidade de Referência criada com sucesso.'

    click_link 'Reais'

    page.should have_field 'Nome', :with => 'Reais'
    page.should have_field 'Sigla', :with => 'R$'
  end

  scenario 'update a reference_unit' do
    ReferenceUnit.make!(:metro)

    click_link 'Cadastros Diversos'

    click_link 'Unidades de Referência'

    click_link 'Metro'

    fill_in 'Nome', :with => 'Centímetro'
    fill_in 'Sigla', :with => 'cm'

    click_button 'Atualizar Unidade de Referência'

    page.should have_notice 'Unidade de Referência editada com sucesso.'

    click_link 'Centímetro'

    page.should have_field 'Nome', :with => 'Centímetro'
    page.should have_field 'Sigla', :with => 'cm'
  end

  scenario 'destroy an existent reference_unit' do
    ReferenceUnit.make!(:metro)

    click_link 'Cadastros Diversos'

    click_link 'Unidades de Referência'

    click_link 'Metro'

    click_link 'Apagar Metro', :confirm => true

    page.should have_notice 'Unidade de Referência apagada com sucesso.'

    page.should_not have_content 'Metro'
  end
end
