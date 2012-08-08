# encoding: utf-8
require 'spec_helper'

feature "Positions" do
  background do
    sign_in
  end

  scenario 'create a new position' do
    navigate 'Outros > Cargos'

    click_link 'Criar Cargo'

    fill_in 'Nome', :with => 'Gerente'

    click_button 'Salvar'

    expect(page).to have_notice 'Cargo criado com sucesso.'

    click_link 'Gerente'

    expect(page).to have_field 'Nome', :with => 'Gerente'
  end

  scenario 'update an existent position' do
    Position.make!(:gerente)

    navigate 'Outros > Cargos'

    click_link 'Gerente'

    fill_in 'Nome', :with => 'Gerente de Setor'

    click_button 'Salvar'

    expect(page).to have_notice 'Cargo editado com sucesso.'

    click_link 'Gerente de Setor'

    expect(page).to have_field 'Nome', :with => 'Gerente de Setor'
  end

  scenario 'destroy an existent position' do
    Position.make!(:gerente)

    navigate 'Outros > Cargos'

    click_link 'Gerente'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Cargo apagado com sucesso.'

    expect(page).not_to have_content 'Gerente'
  end

  scenario 'validate uniqueness of code' do
    Position.make!(:gerente)

    navigate 'Outros > Cargos'

    click_link 'Criar Cargo'

    fill_in 'Nome', :with => 'Gerente'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end
end
