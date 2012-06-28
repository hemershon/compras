# encoding: utf-8
require 'spec_helper'

feature "Agencies" do
  background do
    sign_in
  end

  scenario 'create a new agency' do
    Bank.make!(:banco_do_brasil)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Agências'

    click_link 'Criar Agência'

    fill_modal 'Banco', :with => 'Banco do Brasil'
    fill_in 'Nome', :with => 'Comercial BB'
    fill_in 'Número', :with => '10000'
    fill_in 'Dígito', :with => '3'
    fill_in 'Telefone', :with => '(33) 3333-3333'
    fill_in 'Fax', :with => '(99) 9999-9999'
    fill_in 'E-mail', :with => 'wenderson.malheiros@gmail.com'

    click_button 'Salvar'

    page.should have_notice 'Agência criada com sucesso.'

    click_link 'Comercial BB'

    page.should have_field 'Banco', :with => 'Banco do Brasil'
    page.should have_field 'Nome', :with => 'Comercial BB'
    page.should have_field 'Número', :with => '10000'
    page.should have_field 'Dígito', :with => '3'
    page.should have_field 'Telefone', :with => '(33) 3333-3333'
    page.should have_field 'Fax', :with => '(99) 9999-9999'
    page.should have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
  end

  scenario 'update an existent agency' do
    Bank.make!(:santander)
    Agency.make!(:itau)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Agências'

    click_link 'Agência Itaú'

    fill_modal 'Banco', :with => 'Santander'
    fill_in 'Nome', :with => 'Agência ST'

    click_button 'Salvar'

    page.should have_notice 'Agência editada com sucesso.'

    click_link 'Agência ST'

    page.should have_field 'Banco', :with => 'Santander'
    page.should have_field 'Nome', :with => 'Agência ST'
  end

  scenario 'destroy an existent agency' do
    Agency.make!(:santander)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Agências'

    click_link 'Agência Santander'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Agência apagada com sucesso.'

    page.should_not have_content 'Agência Santander'
  end
end
