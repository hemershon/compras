# encoding: utf-8
require 'spec_helper'

feature "DisseminationSources" do
  background do
    sign_in
  end

  scenario 'create a new dissemination_source' do
    CommunicationSource.make!(:jornal_municipal)

    navigate 'Contabilidade > Comum > Legislação > Fontes de Divulgação'

    click_link 'Criar Fonte de Divulgação'

    fill_in 'Descrição', :with => 'Jornal Oficial do Município'
    fill_modal 'Fonte de comunicação', :with => 'Jornal de Circulação Municipal', :field => 'Descrição'

    click_button 'Salvar'

    page.should have_notice 'Fonte de Divulgação criado com sucesso.'

    click_link 'Jornal Oficial do Município'

    page.should have_field 'Descrição', :with => 'Jornal Oficial do Município'
    page.should have_field 'Fonte de comunicação', :with => 'Jornal de Circulação Municipal'
  end

  scenario 'validates uniqueness of description' do
    DisseminationSource.make!(:jornal_municipal)

    navigate 'Contabilidade > Comum > Legislação > Fontes de Divulgação'

    click_link 'Criar Fonte de Divulgação'

    fill_in 'Descrição', :with => 'Jornal Oficial do Município'

    click_button 'Salvar'

    page.should_not have_notice 'Fonte de Divulgação criado com sucesso.'

    page.should have_content 'já está em uso'
  end

  scenario 'update an existent dissemination_source' do
    DisseminationSource.make!(:jornal_municipal)
    CommunicationSource.make!(:jornal_estadual)

    navigate 'Contabilidade > Comum > Legislação > Fontes de Divulgação'

    click_link 'Jornal Oficial do Município'

    fill_in 'Descrição', :with => 'Jornal Não Oficial do Município'

    fill_modal 'Fonte de comunicação', :with => 'Jornal de Circulação Estadual', :field => 'Descrição'

    click_button 'Salvar'

    page.should have_notice 'Fonte de Divulgação editado com sucesso.'

    click_link 'Jornal Não Oficial do Município'

    page.should have_field 'Descrição', :with => 'Jornal Não Oficial do Município'

    page.should have_field 'Fonte de comunicação', :with => 'Jornal de Circulação Estadual'
  end

  scenario 'destroy an existent dissemination_source' do
    DisseminationSource.make!(:jornal_municipal)

    navigate 'Contabilidade > Comum > Legislação > Fontes de Divulgação'

    click_link 'Jornal Oficial do Município'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Fonte de Divulgação apagado com sucesso.'

    page.should_not have_content 'Jornal Oficial do Município'
    page.should_not have_content 'Jornal de Circulação Municipal'
  end

  scenario 'cannot destroy an existent dissemination_source with regulatory_act relationship' do
    RegulatoryAct.make!(:sopa)

    navigate 'Contabilidade > Comum > Legislação > Fontes de Divulgação'

    click_link 'Jornal Oficial do Bairro'

    click_link 'Apagar', :confirm => true

    page.should_not have_notice 'Fonte de Divulgação apagado com sucesso.'
  end
end
