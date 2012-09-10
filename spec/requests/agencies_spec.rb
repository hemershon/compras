# encoding: utf-8
require 'spec_helper'

feature "Agencies" do
  background do
    sign_in
  end

  scenario 'create a new agency' do
    Bank.make!(:banco_do_brasil)

    navigate 'Compras e Licitações > Cadastros Gerais > Agências'

    click_link 'Criar Agência'

    fill_modal 'Banco', :with => 'Banco do Brasil'
    fill_in 'Nome', :with => 'Comercial BB'
    fill_in 'Número', :with => '10000'
    fill_in 'Dígito', :with => '3'
    fill_in 'Telefone', :with => '(33) 3333-3333'
    fill_in 'Fax', :with => '(99) 9999-9999'
    fill_in 'E-mail', :with => 'wenderson.malheiros@gmail.com'

    click_button 'Salvar'

    expect(page).to have_notice 'Agência criada com sucesso.'

    click_link 'Comercial BB'

    expect(page).to have_field 'Banco', :with => 'Banco do Brasil'
    expect(page).to have_field 'Nome', :with => 'Comercial BB'
    expect(page).to have_field 'Número', :with => '10000'
    expect(page).to have_field 'Dígito', :with => '3'
    expect(page).to have_field 'Telefone', :with => '(33) 3333-3333'
    expect(page).to have_field 'Fax', :with => '(99) 9999-9999'
    expect(page).to have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
  end

  scenario 'update an existent agency' do
    Bank.make!(:santander)
    Agency.make!(:itau)

    navigate 'Compras e Licitações > Cadastros Gerais > Agências'

    click_link 'Agência Itaú'

    fill_modal 'Banco', :with => 'Santander'
    fill_in 'Nome', :with => 'Agência ST'

    click_button 'Salvar'

    expect(page).to have_notice 'Agência editada com sucesso.'

    click_link 'Agência ST'

    expect(page).to have_field 'Banco', :with => 'Santander'
    expect(page).to have_field 'Nome', :with => 'Agência ST'
  end

  scenario 'destroy an existent agency' do
    Agency.make!(:santander)

    navigate 'Compras e Licitações > Cadastros Gerais > Agências'

    click_link 'Agência Santander'

    click_link 'Apagar'

    expect(page).to have_notice 'Agência apagada com sucesso.'

    expect(page).not_to have_content 'Agência Santander'
  end
end
