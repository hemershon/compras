# encoding: utf-8
require 'spec_helper'

feature "Descriptors" do
  background do
    sign_in
  end

  scenario 'create a new descriptor' do
    Entity.make!(:detran)

    navigate 'Outros > Descritores'

    click_link 'Criar Descritor'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'

    click_button 'Salvar'

    expect(page).to have_notice 'Descritor criado com sucesso.'

    click_link '2012 - Detran'

    expect(page).to have_field 'Entidade', :with => 'Detran'
    expect(page).to have_field 'Exercício', :with => '2012'
  end

  scenario 'update an existent descriptor' do
    Descriptor.make!(:detran_2012)
    Entity.make!(:secretaria_de_educacao)

    navigate 'Outros > Descritores'

    click_link '2012 - Detran'

    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Exercício', :with => '2011'

    click_button 'Salvar'

    expect(page).to have_notice 'Descritor editado com sucesso.'

    click_link '2011 - Secretaria de Educação'

    expect(page).to have_field 'Entidade', :with => 'Secretaria de Educação'
    expect(page).to have_field 'Exercício', :with => '2011'
  end

  scenario 'destroy an existent descriptor' do
    Descriptor.make!(:detran_2012)

    navigate 'Outros > Descritores'

    click_link '2012 - Detran'

    click_link 'Apagar'

    expect(page).to have_notice 'Descritor apagado com sucesso.'

    expect(page).to_not have_content 'Detran'
    expect(page).to_not have_content '2012'
  end
end
