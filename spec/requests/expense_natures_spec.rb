# encoding: utf-8
require 'spec_helper'

feature "ExpenseNatures" do
  background do
    sign_in
  end

  scenario 'create a new expense_nature' do
    Descriptor.make!(:detran_2012)
    RegulatoryAct.make!(:sopa)
    ExpenseCategory.make!(:despesa_corrente)
    ExpenseGroup.make!(:restos_a_pagar)
    ExpenseModality.make!(:transferencias_intragovernamentais)
    ExpenseElement.make!(:aposentadorias)

    navigate_through 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

    click_link 'Criar Natureza da Despesa'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
    fill_modal 'Categoria da despesa', :with => '3', :field => 'Código'
    fill_modal 'Grupo da despesa', :with => '0', :field => 'Código'
    fill_modal 'Modalidade da despesa', :with => '10', :field => 'Código'
    fill_modal 'Elemento da despesa', :with => '1', :field => 'Código'
    fill_in 'Desdobramento da despesa', :with => '12'
    select 'Ambos', :from => 'Tipo'
    fill_in 'Descrição', :with => 'Vencimentos e Salários'
    fill_in 'Súmula', :with => 'Registra o valor das despesas com vencimentos'

    click_button 'Salvar'

    page.should have_notice 'Natureza da Despesa criado com sucesso'

    click_link '3.0.10.01.12 - Vencimentos e Salários'

    page.should have_field 'Descritor', :with => '2012 - Detran'
    page.should have_field 'Ato regulamentador', :with => '1234'
    page.should have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
    page.should have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
    page.should have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'
    page.should have_field 'Desdobramento da despesa', :with => '12'
    page.should have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
    page.should have_field 'Natureza da despesa', :with => '3.0.10.01.12'
    page.should have_select 'Tipo', :selected => 'Ambos'
    page.should have_field 'Descrição', :with => 'Vencimentos e Salários'
    page.should have_field 'Súmula', :with => 'Registra o valor das despesas com vencimentos'
  end

  scenario 'should generate mask' do
    ExpenseCategory.make!(:despesa_corrente)
    ExpenseGroup.make!(:restos_a_pagar)
    ExpenseModality.make!(:transferencias_intragovernamentais)
    ExpenseElement.make!(:aposentadorias)

    navigate_through 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

    click_link 'Criar Natureza da Despesa'

    fill_modal 'Categoria da despesa', :with => '3', :field => 'Código'

    fill_modal 'Grupo da despesa', :with => '0', :field => 'Código'
    page.should have_field 'Natureza da despesa', :with => '3.0.00.00.00'

    fill_modal 'Modalidade da despesa', :with => '10', :field => 'Código'

    fill_modal 'Elemento da despesa', :with => '1', :field => 'Código'
    page.should have_field 'Natureza da despesa', :with => '3.0.10.01.00'

    fill_in 'Desdobramento da despesa', :with => '12'

    page.should have_field 'Natureza da despesa', :with => '3.0.10.01.12'
  end

  scenario 'update an existent expense_nature' do
    ExpenseNature.make!(:vencimento_e_salarios)
    Descriptor.make!(:secretaria_de_educacao_2011)
    RegulatoryAct.make!(:emenda)
    ExpenseCategory.make!(:despesa_de_capital)
    ExpenseGroup.make!(:investimentos)
    ExpenseModality.make!(:transferencias_a_uniao)
    ExpenseElement.make!(:pensoes)

    navigate_through 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

    click_link '3.0.10.01.12 - Vencimentos e Salários'

    fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
    fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
    fill_modal 'Grupo da despesa', :with => '4', :field => 'Código'
    fill_modal 'Modalidade da despesa', :with => '20', :field => 'Código'
    fill_modal 'Categoria da despesa', :with => '4', :field => 'Código'
    fill_modal 'Elemento da despesa', :with => '3', :field => 'Código'
    fill_in 'Desdobramento da despesa', :with => '11'
    select 'Analítico', :from => 'Tipo'
    fill_in 'Descrição', :with => 'Vencimentos e Salários e Pagamento'
    fill_in 'Súmula', :with => 'Registra o valor das despesas com vencimentos de salários'

    click_button 'Salvar'

    page.should have_notice 'Natureza da Despesa editado com sucesso.'

    click_link '4.4.20.03.11'

    page.should have_field 'Descritor', :with => '2011 - Secretaria de Educação'
    page.should have_field 'Ato regulamentador', :with => '4567'
    page.should have_field 'Grupo da despesa', :with => '4 - INVESTIMENTOS'
    page.should have_field 'Modalidade da despesa', :with => '20 - TRANSFERÊNCIAS À UNIÃO'
    page.should have_field 'Elemento da despesa', :with => '3 - PENSÕES'
    page.should have_field 'Desdobramento da despesa', :with => '11'
    page.should have_field 'Categoria da despesa', :with => '4 - DESPESA DE CAPITAL'
    page.should have_field 'Natureza da despesa', :with => '4.4.20.03.11'
    page.should have_select 'Tipo', :selected => 'Analítico'
    page.should have_field 'Descrição', :with => 'Vencimentos e Salários e Pagamento'
    page.should have_field 'Súmula', :with => 'Registra o valor das despesas com vencimentos de salários'
  end

  scenario 'destroy an existent expense_nature' do
    ExpenseNature.make!(:vencimento_e_salarios)

    navigate_through 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

    click_link '3.0.10.01.12 - Vencimentos e Salários'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Natureza da Despesa apagado com sucesso.'

    page.should_not have_field '3.0.10.01.12'
  end
end
