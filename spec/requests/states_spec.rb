# encoding: utf-8
require 'spec_helper'

feature "States" do
  background do
    sign_in
  end

  scenario 'create a new state' do
    Country.make!(:brasil)

    navigate 'Geral > Parâmetros > Endereços > Estados'

    click_link 'Criar Estado'

    fill_in 'Nome', :with => 'Minas Gerais'
    fill_in 'Sigla', :with => 'MG'
    fill_modal 'País', :with => 'Brasil'

    click_button 'Salvar'

    expect(page).to have_notice 'Estado criado com sucesso.'

    click_link 'Minas Gerais'

    expect(page).to have_field 'Nome', :with => 'Minas Gerais'
    expect(page).to have_field 'Sigla', :with => 'MG'
    expect(page).to have_field 'País', :with => 'Brasil'
  end

  scenario 'update a state' do
    State.make!(:rs)

    navigate 'Geral > Parâmetros > Endereços > Estados'

    click_link 'Rio Grande do Sul'

    fill_in 'Nome', :with => 'Rio Grande do Norte'

    click_button 'Salvar'

    expect(page).to have_notice 'Estado editado com sucesso.'

    click_link 'Rio Grande do Norte'

    expect(page).to have_field 'Nome', :with => 'Rio Grande do Norte'
  end

  scenario 'destroy a state' do
    State.make!(:rs)

    navigate 'Geral > Parâmetros > Endereços > Estados'

    click_link 'Rio Grande do Sul'

    click_link 'Apagar'

    expect(page).to have_notice 'Estado apagado com sucesso.'

    expect(page).to_not have_content 'Rio Grande do Sul'
    expect(page).to_not have_content 'RS'
  end

  scenario 'index with columns at the index' do
    State.make!(:rs)

    navigate 'Geral > Parâmetros > Endereços > Estados'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Sigla'
      expect(page).to have_content 'País'

      within 'tbody tr' do
        expect(page).to have_content 'Rio Grande do Sul'
        expect(page).to have_content 'RS'
        expect(page).to have_content 'Brasil'
      end
    end
  end
end
