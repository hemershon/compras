# encoding: utf-8
require 'spec_helper'

feature "Profiles" do
  background do
    sign_in
  end

  scenario 'create a new profile' do
    navigate 'Outros > Perfis'

    click_link 'Criar Perfil'

    fill_in 'Nome', :with => 'Gestor'

    click_button 'Salvar'

    expect(page).to have_notice 'Perfil criado com sucesso.'

    click_link 'Gestor'

    expect(page).to have_field 'Nome', :with => 'Gestor'
  end

  scenario 'update a profile' do
    Profile.make!(:manager)

    navigate 'Outros > Perfis'

    click_link 'Gestor'

    fill_in 'Nome', :with => 'Gestão'

    click_button 'Salvar'

    expect(page).to have_notice 'Perfil editado com sucesso.'

    click_link 'Gestão'

    expect(page).to have_field 'Nome', :with => 'Gestão'
  end

  scenario 'destroy a profile' do
    Profile.make!(:manager)

    navigate 'Outros > Perfis'

    click_link 'Gestor'

    click_link 'Apagar'

    expect(page).to have_notice 'Perfil apagado com sucesso.'

    within_records do
      expect(page).not_to have_content 'Gestor'
    end
  end
end
