# encoding: utf-8
require 'spec_helper'

feature "ManagementUnits" do
  background do
    sign_in
  end

  scenario 'create a new management_unit' do
    Descriptor.make!(:detran_2012)

    navigate 'Contabilidade > Orçamento > Estrutura Organizacional > Unidades Gestoras'

    click_link 'Criar Unidade Gestora'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Unidade Central'
    fill_in 'Sigla', :with => 'UGC'
    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    page.should have_notice 'Unidade Gestora criada com sucesso.'

    click_link 'Unidade Central'

    page.should have_field 'Descritor', :with => '2012 - Detran'
    page.should have_field 'Descrição', :with => 'Unidade Central'
    page.should have_field 'Sigla', :with => 'UGC'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent management_unit' do
    ManagementUnit.make!(:unidade_central)
    Descriptor.make!(:secretaria_de_educacao_2013)

    navigate 'Contabilidade > Orçamento > Estrutura Organizacional > Unidades Gestoras'

    click_link 'Unidade Central'

    fill_modal 'Descritor', :with => '2013', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Unidade Auxiliar'
    fill_in 'Sigla', :with => 'UGA'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Unidade Gestora editada com sucesso.'

    click_link 'Unidade Auxiliar'

    page.should have_field 'Descritor', :with => '2013 - Secretaria de Educação'
    page.should have_field 'Descrição', :with => 'Unidade Auxiliar'
    page.should have_field 'Sigla', :with => 'UGA'
    page.should have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent management_unit' do
    ManagementUnit.make!(:unidade_central)

    navigate 'Contabilidade > Orçamento > Estrutura Organizacional > Unidades Gestoras'

    click_link 'Unidade Central'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Unidade Gestora apagada com sucesso.'

    page.should_not have_content 'Unidade Central'
    page.should_not have_content 'UGC'
    page.should_not have_content 'Ativo'
  end
end
