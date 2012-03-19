# encoding: utf-8
require 'spec_helper'

feature "Periods" do
  background do
    sign_in
  end

  scenario 'create a new period' do
    click_link 'Cadastros Diversos'

    click_link 'Prazos'

    click_link 'Criar Prazo'

    select 'ano', :from => 'Unidade'
    fill_in 'Quantidade', :with => '1'

    click_button 'Criar Prazo'

    page.should have_notice 'Prazo criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Quantidade', :with => '1'
    page.should have_select 'Unidade', :selected => 'ano'
  end

  scenario 'update an existent period' do
    Period.make!(:um_ano)

    click_link 'Cadastros Diversos'

    click_link 'Prazos'

    within_records do
      page.find('a').click
    end

    select 'dia', :from => 'Unidade'
    fill_in 'Quantidade', :with => '30'

    click_button 'Atualizar Prazo'

    page.should have_notice 'Prazo editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Quantidade', :with => '30'
    page.should have_select 'Unidade', :selected => 'dia'
  end

  scenario 'destroy an existent period' do
    Period.make!(:um_ano)

    click_link 'Cadastros Diversos'

    click_link 'Prazos'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar 1 ano', :confirm => true

    page.should have_notice 'Prazo apagado com sucesso.'

    page.should_not have_content 1
    page.should_not have_content 'ano'
  end
end
