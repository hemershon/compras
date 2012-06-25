# encoding: utf-8
require 'spec_helper'

feature "RegulatoryActs" do
  background do
    sign_in
  end

  scenario 'create a new regulatory_act' do
    make_dependencies!

    click_link 'Contabilidade'

    click_link 'Atos Regulamentadores'

    click_link 'Criar Ato Regulamentador'

    within_tab "Principal" do
      fill_in 'Número', :with => '1234'
      fill_modal 'Tipo', :with => 'Lei', :field => 'Descrição'
      fill_modal 'Natureza legal do texto jurídico', :with => 'Natureza Cívica', :field => 'Descrição'
      fill_in 'Data da criação', :with => '01/01/2012'
      fill_in 'Data da publicação', :with => '02/01/2012'
      fill_in 'Data a vigorar', :with => '03/01/2012'
      fill_in 'Data do término', :with => '09/01/2012'
      fill_in 'Ementa', :with => 'conteudo'
    end

    within_tab "Complementar" do
      fill_in 'Porcentagem de lei orçamentaria', :with => '5,00'
      fill_in 'Porcentagem de antecipação da receita', :with => '3,00'
      fill_in 'Valor autorizado da dívida', :with => '7.000,00'
    end

    within_tab 'Fontes de divulgação' do
      fill_modal 'Fonte de divulgação', :with => 'Jornal Oficial do Município', :field => 'Descrição'
    end

    click_button 'Salvar'

    page.should have_notice 'Ato Regulamentador criado com sucesso.'

    click_link '1234'

    within_tab 'Principal' do
      page.should have_field 'Número', :with => '1234'
      page.should have_field 'Tipo', :with => 'Lei'
      page.should have_field 'Natureza legal do texto jurídico', :with => 'Natureza Cívica'
      page.should have_field 'Data da criação', :with => '01/01/2012'
      page.should have_field 'Data da publicação', :with => '02/01/2012'
      page.should have_field 'Data a vigorar', :with => '03/01/2012'
      page.should have_field 'Data do término', :with => '09/01/2012'
      page.should have_field 'Ementa', :with => 'conteudo'
    end

    within_tab 'Complementar' do
      page.should have_field 'Porcentagem de lei orçamentaria', :with => '5,00'
      page.should have_field 'Porcentagem de antecipação da receita', :with => '3,00'
      page.should have_field 'Valor autorizado da dívida', :with => '7.000,00'
    end

    within_tab 'Fontes de divulgação' do
      page.should have_content 'Jornal Oficial do Município'
    end
  end

  scenario 'update an existent regulatory_act' do
    make_dependencies!
    RegulatoryActType.make!(:emenda)
    RegulatoryAct.make!(:sopa)
    DisseminationSource.make!(:jornal_bairro)
    LegalTextNature.make!(:trabalhista)

    click_link 'Contabilidade'

    click_link 'Atos Regulamentadores'

    click_link '1234'

    within_tab 'Principal' do
      fill_in 'Número', :with => '6789'
      fill_modal 'Tipo', :with => 'Emenda constitucional', :field => 'Descrição'
      fill_modal 'Natureza legal do texto jurídico', :with => 'Natureza Trabalhista', :field => 'Descrição'
      fill_in 'Data da criação', :with => '01/01/2013'
      fill_in 'Data da publicação', :with => '02/01/2013'
      fill_in 'Data a vigorar', :with => '03/01/2013'
      fill_in 'Data do término', :with => '09/01/2013'
      fill_in 'Ementa', :with => 'novo conteudo'
    end

    within_tab 'Complementar' do
      fill_in 'Porcentagem de lei orçamentaria', :with => '15,00'
      fill_in 'Porcentagem de antecipação da receita', :with => '13,00'
      fill_in 'Valor autorizado da dívida', :with => '17.000,00'
    end

    within_tab 'Fontes de divulgação' do
      fill_modal 'Fonte de divulgação', :with => 'Jornal Oficial do Bairro', :field => 'Descrição'
    end

    click_button 'Salvar'

    page.should have_notice 'Ato Regulamentador editado com sucesso.'

    click_link '6789'

    within_tab 'Principal' do
      page.should have_field 'Número', :with => '6789'
      page.should have_field 'Tipo', :with => 'Emenda constitucional'
      page.should have_field 'Natureza legal do texto jurídico', :with => 'Natureza Trabalhista'
      page.should have_field 'Data da criação', :with => '01/01/2013'
      page.should have_field 'Data da publicação', :with => '02/01/2013'
      page.should have_field 'Data a vigorar', :with => '03/01/2013'
      page.should have_field 'Data do término', :with => '09/01/2013'
      page.should have_field 'Ementa', :with => 'novo conteudo'
    end

    within_tab 'Complementar' do
      page.should have_field 'Porcentagem de lei orçamentaria', :with => '15,00'
      page.should have_field 'Porcentagem de antecipação da receita', :with => '13,00'
      page.should have_field 'Valor autorizado da dívida', :with => '17.000,00'
    end

    within_tab 'Fontes de divulgação' do
      page.should have_content 'Jornal Oficial do Bairro'
    end
  end

  scenario 'destroy an existent regulatory_act' do
    RegulatoryAct.make!(:sopa)
    click_link 'Contabilidade'

    click_link 'Atos Regulamentadores'

    click_link '1234'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Ato Regulamentador apagado com sucesso.'

    page.should_not have_link '1234'
  end

  scenario 'should validate uniqueness of act_number' do
    RegulatoryAct.make!(:sopa)

    click_link 'Contabilidade'

    click_link 'Atos Regulamentadores'

    click_link 'Criar Ato Regulamentador'

    fill_in 'Número', :with => '1234'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end

  scenario 'should validate uniqueness of content' do
    RegulatoryAct.make!(:sopa)

    click_link 'Contabilidade'

    click_link 'Atos Regulamentadores'

    click_link 'Criar Ato Regulamentador'

    fill_in 'Ementa', :with => 'conteudo'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end

  scenario 'remove dissemination source from an existent regulatory_act' do
    RegulatoryAct.make!(:sopa)

    click_link 'Contabilidade'

    click_link 'Atos Regulamentadores'

    click_link '1234'

    within_tab 'Fontes de divulgação' do
      click_button 'Remover'
    end

    click_button 'Salvar'

    page.should have_notice 'Ato Regulamentador editado com sucesso.'

    click_link '1234'

    within_tab 'Fontes de divulgação' do
      page.should_not have_content 'Jornal Oficial do Bairro'
    end
  end

  def make_dependencies!
    RegulatoryActType.make!(:lei)
    DisseminationSource.make!(:jornal_municipal)
    LegalTextNature.make!(:civica)
  end
end
