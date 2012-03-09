# encoding: utf-8
require 'spec_helper'

feature "DirectPurchases" do
  background do
    sign_in
  end

  scenario 'create a new direct_purchase' do
    LegalReference.make!(:referencia)
    provider = Provider.make!(:wenderson_sa)
    Organogram.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Period.make!(:um_ano)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referencia legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      fill_modal 'Fornecedor', :with => '456789', :field => 'Número'
      fill_modal 'Unidade orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Prazo', :with => '1', :field => 'Quantidade'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Reg. de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'

      # getting data from modal
      page.should have_field 'Classificação econômica de despesa', :with => '3.1.90.11.01.00.00.00'
      page.should have_field 'Saldo da dotação', :with => '500,00'

      select 'Global', :from => 'Tipo do empenho'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      page.should have_field 'Unidade', :with => 'Unidade'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3'
      fill_in 'Valor unitário', :with => '200,00'

      # asserting calculated total price of the item
      page.should have_field 'Valor total', :with => '600,00'
    end

    click_button 'Criar Solicitação de Compra Direta'

    page.should have_notice 'Compra Direta criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data da compra', :with => '19/03/2012'
      page.should have_field 'Referencia legal', :with => 'Referencia legal'
      page.should have_select 'Modalidade', :selected => 'Material ou serviços'
      page.should have_field 'Fornecedor', :with => provider.id.to_s
      page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Educação'
      page.should have_field 'Objeto da licitação', :with => 'Ponte'
      page.should have_field 'Local de entrega', :with => 'Secretaria da Educação'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Prazo', :with => '1 - Ano'
      page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
      page.should have_field 'Coleta de preços', :with => '99'
      page.should have_field 'Reg. de preços', :with => '88'
      page.should have_field 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      page.should have_field 'Dotação orçamentária', :with => "#{budget_allocation.id}/2012"
      page.should have_field 'Classificação econômica de despesa', :with => '3.1.90.11.01.00.00.00'
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_select 'Tipo do empenho', :selected => 'Global'

      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should have_field 'Unidade', :with => 'Unidade'
      page.should have_field 'Marca/Referência', :with => 'Norton'
      page.should have_field 'Quantidade', :with => '3'
      page.should have_field 'Valor unitário', :with => '200,00'
      page.should have_field 'Valor total', :with => '600,00'
    end
  end

  scenario 'should have all fields disabled when edit an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Atualizar Solicitação de Compra Direta'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Ano'
      page.should have_disabled_field 'Data da compra'
      page.should have_disabled_field 'Referencia legal'
      page.should have_disabled_field 'Modalidade'
      page.should have_disabled_field 'Fornecedor'
      page.should have_disabled_field 'Unidade orçamentária'
      page.should have_disabled_field 'Objeto da licitação'
      page.should have_disabled_field 'Local de entrega'
      page.should have_disabled_field 'Responsável'
      page.should have_disabled_field 'Prazo'
      page.should have_disabled_field 'Forma de pagamento'
      page.should have_disabled_field 'Coleta de preços'
      page.should have_disabled_field 'Reg. de preços'
      page.should have_disabled_field 'Observações gerais'
    end

    within_tab 'Dotações' do
      page.should have_disabled_field 'Dotação orçamentária'
      page.should have_disabled_field 'Classificação econômica de despesa'
      page.should have_disabled_field 'Saldo da dotação'
      page.should have_disabled_field 'Tipo do empenho'
      page.should have_disabled_field 'Material'
      page.should have_disabled_field 'Unidade'
      page.should have_disabled_field 'Marca/Referência'
      page.should have_disabled_field 'Quantidade'
      page.should have_disabled_field 'Valor unitário'
      page.should have_disabled_field 'Valor total'
      page.should_not have_button 'Adicionar Dotação'
      page.should_not have_button 'Remover Dotação'
      page.should_not have_button 'Adicionar Item'
      page.should_not have_button 'Remover Item'
    end
  end

  scenario 'should not have destroy button when edit an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Apagar'
  end

  scenario 'asserting that duplicated budget allocations cannot be saved' do
    LegalReference.make!(:referencia)
    provider = Provider.make!(:wenderson_sa)
    Organogram.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Period.make!(:um_ano)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referencia legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      fill_modal 'Fornecedor', :with => '456789', :field => 'Número'
      fill_modal 'Unidade orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Prazo', :with => '1', :field => 'Quantidade'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Reg. de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
      select 'Global', :from => 'Tipo do empenho'

      click_button 'Adicionar Dotação'

      within '.direct-purchase-budget-allocation:last' do
        fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
        select 'Ordinário', :from => 'Tipo do empenho'
      end
    end

    click_button 'Criar Solicitação de Compra Direta'

    within_tab 'Dotações' do
      page.should have_content 'já está em uso'
    end
  end
end
