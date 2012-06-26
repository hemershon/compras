# encoding: utf-8
require 'spec_helper'

feature "Countries" do
  background do
    sign_in
  end

  scenario 'create a new country' do
    navigate_through 'Outros > Países'

    click_link 'Criar País'

    fill_in 'Nome', :with => 'Argentina'

    click_button 'Salvar'

    page.should have_notice 'País criado com sucesso.'

    click_link 'Argentina'

    page.should have_field 'Nome', :with => 'Argentina'
  end

  scenario 'update a country' do
    Country.make!(:brasil)

    navigate_through 'Outros > Países'

    click_link 'Brasil'

    fill_in 'Nome', :with => 'Argentina'

    click_button 'Salvar'

    page.should have_notice 'País editado com sucesso.'

    click_link 'Argentina'

    page.should have_field 'Nome', :with => 'Argentina'
  end

  scenario 'destroy a country' do
    Country.make!(:argentina)

    navigate_through 'Outros > Países'

    click_link 'Argentina'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'País apagado com sucesso.'

    page.should_not have_content 'Argentina'
  end
end
