# encoding: utf-8
require 'spec_helper'

feature "PurchaseSolicitations" do
  background do
    sign_in
  end

  scenario 'create a new purchase_solicitation' do
    make_dependencies!

    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Liberação'
      page.should have_disabled_field 'Por'
      page.should have_disabled_field 'Observações do atendimento'
      page.should have_disabled_field 'Justificativa para não atendimento'
      page.should have_disabled_field 'Status de atendimento'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Unidade orçamentária solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Dotação orçamentária', :with => 'Alocação', :field => 'Nome'

      # testing javascript getting amount of allocation
      page.should have_disabled_field 'Saldo da dotação'
      page.should have_field 'Saldo da dotação', :with => '500,00'
      # end of javascript test

      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Itens' do
      click_button "Adicionar Item"

      page.should have_disabled_field "Agrupado"
      page.should have_disabled_field "Número do processo de compra"
      page.should have_disabled_field "Status"

      fill_modal 'Material', :with => "Cadeira", :field => "Descrição"
      page.should have_field 'Unidade de referência', :with => "Unidade"
      fill_in 'Quantidade', :with => "5"
      fill_in 'Preço unitário', :with => "100,00"
      page.should have_select 'Status', :selected => 'Pendente'
    end

    click_button 'Criar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra criada com sucesso.'

    click_link 'Novas cadeiras'

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data da solicitação', :with => '01/02/2012'
      page.should have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho', :field => 'Matrícula'
      page.should have_field 'Unidade orçamentária solicitante', :with => 'Secretaria de Educação'
      page.should have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      page.should have_field 'Dotação orçamentária', :with => 'Alocação'
      page.should have_field 'Local para entrega', :selected => 'Secretaria da Educação'
      page.should have_select 'Tipo de solicitação', :with => 'Bens'
      page.should have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      page.should have_select 'Status de atendimento', :selected => 'Pendente'
    end

    within_tab 'Itens' do
      page.should have_field 'Material', :with => "02.02.00001 - Cadeira"
      page.should have_field 'Unidade de referência', :with => "Unidade"
      page.should have_field 'Quantidade', :with => "5"
      page.should have_field 'Preço unitário', :with => "100,00"
      page.should have_field 'Preço total estimado', :with => "500,00"
      page.should have_select 'Status', :selected => 'Pendente'
    end
  end

  scenario 'clear extra budget_allocations on new view' do
    pending "Don't work with hidden alements"
    make_dependencies!
    BudgetAllocation.make!(:conserto)

    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Dotações orçamentárias' do
      click_button 'Adicionar'
      fill_modal 'Dotação', :with => 'Conserto'
    end

    within_tab 'Dados gerais' do
      fill_modal 'Dotação orçamentária', :with => 'Alocação'
    end

    within_tab 'Dotações orçamentárias' do
      page.should have_content 'Dotação selecionada na aba "Dados gerais"'
      page.should_not have_content 'Conserto'
      page.should_not have_content 'Total previsto dos itens'
      page.should_not have_content 'Soma dos valores das dotações'
    end
  end

  scenario 'create a new purchase_solicitation with multiple budget_allocations' do
    make_dependencies!
    BudgetAllocation.make!(:alocacao_extra)

    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Liberação'
      page.should have_disabled_field 'Por'
      page.should have_disabled_field 'Observações do atendimento'
      page.should have_disabled_field 'Justificativa para não atendimento'
      page.should have_disabled_field 'Status de atendimento'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Unidade orçamentária solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Itens' do
      click_button "Adicionar Item"

      page.should have_disabled_field "Agrupado"
      page.should have_disabled_field "Número do processo de compra"
      page.should have_disabled_field "Status"

      fill_modal 'Material', :with => "Cadeira", :field => "Descrição"
      page.should have_field 'Unidade de referência', :with => "Unidade"
      fill_in 'Quantidade', :with => "5"
      fill_in 'Preço unitário', :with => "100,00"
      page.should have_select 'Status', :selected => 'Pendente'
    end

    within_tab 'Dotações orçamentárias' do
      # testing javascript total items calculation
      page.should have_field 'Total previsto dos itens', :with => '500,00'
      page.should have_disabled_field 'Total previsto dos itens'

      click_button "Adicionar"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => 'Alocação'
        fill_in 'Compl. do el. da despesa', :with => '50,00'
        fill_in 'Valor previsto', :with => '200,00'
      end

      click_button "Adicionar"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => 'Alocação extra'
        fill_in 'Compl. do el. da despesa', :with => '50,00'
        fill_in 'Valor previsto', :with => '300,00'
      end

      # testing javascript total allocations calculation
      page.should have_field 'Soma dos valores das dotações', :with => '500,00'
      page.should have_disabled_field 'Soma dos valores das dotações'
    end

    click_button 'Criar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra criada com sucesso.'

    click_link 'Novas cadeiras'

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data da solicitação', :with => '01/02/2012'
      page.should have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho', :field => 'Matrícula'
      page.should have_field 'Unidade orçamentária solicitante', :with => 'Secretaria de Educação'
      page.should have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      page.should have_field 'Local para entrega', :selected => 'Secretaria da Educação'
      page.should have_select 'Tipo de solicitação', :with => 'Bens'
      page.should have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      page.should have_select 'Status de atendimento', :selected => 'Pendente'
    end

    within_tab 'Itens' do
      page.should have_field 'Material', :with => "02.02.00001 - Cadeira"
      page.should have_field 'Unidade de referência', :with => "Unidade"
      page.should have_field 'Quantidade', :with => "5"
      page.should have_field 'Preço unitário', :with => "100,00"
      page.should have_field 'Preço total estimado', :with => "500,00"
      page.should have_select 'Status', :selected => 'Pendente'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        page.should have_field "Dotação", :with => 'Alocação'
        page.should have_field 'Compl. do el. da despesa', :with => '50,00'
        page.should have_field "Valor previsto", :with => '200,00'
      end

      within '.purchase-solicitation-budget-allocation:last' do
        page.should have_field "Dotação", :with => 'Alocação extra'
        page.should have_field 'Compl. do el. da despesa', :with => '50,00'
        page.should have_field "Valor previsto", :with => '300,00'
      end
    end
  end

  scenario 'showing a message for no extra allocation when allocation is selected on general tab' do
    pending "Don't work with hidden alements"
    make_dependencies!

    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Dados gerais' do
      fill_modal 'Dotação orçamentária', :with => 'Alocação'
    end

    within_tab 'Dotações orçamentárias' do
      page.should have_content 'Dotação selecionada na aba "Dados gerais"'
    end
  end

  scenario 'update an existent purchase_solicitation' do
    make_dependencies!

    PurchaseSolicitation.make!(:reparo)
    Employee.make!(:wenderson)
    BudgetAllocation.make!(:alocacao_extra)
    DeliveryLocation.make!(:health)
    Material.make!(:manga)
    Organogram.make!(:secretaria_de_desenvolvimento)

    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Reparo nas instalações'

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2013'
      fill_in 'Data da solicitação', :with => '01/02/2013'
      fill_modal 'Responsável pela solicitação', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Unidade orçamentária solicitante', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
      fill_in 'Justificativa da solicitação', :with => 'Novas mesas'
      fill_modal 'Dotação orçamentária', :with => 'Alocação extra'
      fill_modal 'Local para entrega', :with => 'Secretaria da Saúde', :field => "Descrição"
      select 'Serviços', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Itens' do
      click_button "Remover Item"

      click_button "Adicionar Item"

      fill_modal 'Material', :with => "Manga", :field => "Descrição"
      page.should have_field 'Unidade de referência', :with => "Quilos"
      fill_in 'Quantidade', :with => "500"
      fill_in 'Preço unitário', :with => "2,00"
    end

    click_button 'Atualizar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra editada com sucesso.'

    click_link 'Novas mesas'

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2013'
      page.should have_field 'Data da solicitação', :with => '01/02/2013'
      page.should have_field 'Responsável pela solicitação', :with => 'Wenderson Malheiros', :field => 'Matrícula'
      page.should have_field 'Unidade orçamentária solicitante', :with => 'Secretaria de Desenvolvimento'
      page.should have_field 'Justificativa da solicitação', :with => 'Novas mesas'
      page.should have_field 'Dotação orçamentária', :with => 'Alocação extra'
      page.should have_field 'Local para entrega', :with => 'Secretaria da Saúde'
      page.should have_select 'Tipo de solicitação', :selected => 'Serviços'
      page.should have_field 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Itens' do
      page.should have_field 'Material', :with => "01.01.00001 - Manga", :field => "Descrição"
      page.should have_field 'Quantidade', :with => "500"
      page.should have_field 'Preço unitário', :with => "2,00"
      page.should have_field 'Preço total estimado', :with => "1.000,00"
      page.should have_select 'Status', :selected => 'Pendente'
    end
  end

  scenario 'change multiple budget_allocations with one budget_allocation' do
    pending "Don't work with hidden alements"
    make_dependencies!
    PurchaseSolicitation.make!(:conserto)
    BudgetAllocation.make!(:conserto)

    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Reparo nas instalações'

    within_tab 'Dados gerais' do
      fill_modal 'Dotação orçamentária', :with => 'Conserto'
    end

    click_button 'Atualizar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra editada com sucesso.'

    click_link 'Reparo nas instalações'

    within_tab 'Dotações orçamentárias' do
      page.should have_content 'Dotação selecionada na aba "Dados gerais"'
      page.should_not have_content 'Alocação'
    end
  end

  scenario 'destroy an existent purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo)
    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Reparo nas instalações'

    click_link 'Apagar Reparo nas instalações', :confirm => true

    page.should have_notice 'Solicitação de Compra apagada com sucesso.'

    page.should_not have_content '2012'
    page.should_not have_content '31/01/2012'
    page.should_not have_content 'Gabriel Sobrinho'
    page.should_not have_content 'Reparo nas instalações'
    page.should_not have_content 'Bens'
  end

  scenario 'remove budget allocation from an existent purchase_solicitation' do
    PurchaseSolicitation.make!(:conserto)

    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Reparo nas instalações'

    within_tab 'Dotações orçamentárias' do
      click_button 'Remover'
    end

    click_button 'Atualizar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra editada com sucesso.'

    click_link 'Reparo nas instalações'

    within_tab 'Dotações orçamentárias' do
      page.should_not have_content 'Alocação'
    end
  end

  scenario 'cannot save with the same material selected more than once on items' do
    make_dependencies!

    PurchaseSolicitation.make!(:conserto)

    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Reparo nas instalações'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_modal 'purchase_solicitation_items_attributes_fresh-0_material', :with => "Cadeira", :field => "Descrição"
      fill_in 'purchase_solicitation_items_attributes_fresh-0_quantity', :with => "5"
      fill_in 'purchase_solicitation_items_attributes_fresh-0_unit_price', :with => "100,00"
      fill_in 'purchase_solicitation_items_attributes_fresh-0_estimated_total_price', :with => "500,00"
    end

    click_button 'Atualizar Solicitação de Compra'

    within_tab 'Itens' do
      page.should have_content "não é permitido adicionar mais de um item com o mesmo material"
    end
  end

  scenario 'calculate total item price via javascript' do
    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_in 'Quantidade', :with => "5"
      fill_in 'Preço unitário', :with => "100,00"

      page.should have_disabled_field 'Preço total estimado'
      page.should have_field 'Preço total estimado', :with => '500,00'
    end
  end

  scenario 'clean the budget amount when removing budget allocation' do
    pending
  end

  def make_dependencies!
    Employee.make!(:sobrinho)
    BudgetAllocation.make!(:alocacao)
    DeliveryLocation.make!(:education)
    Material.make!(:cadeira)
    Organogram.make!(:secretaria_de_educacao)
  end
end
