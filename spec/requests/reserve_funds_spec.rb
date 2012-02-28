# encoding: utf-8
require 'spec_helper'

feature "ReserveFunds" do
  background do
    sign_in
  end

  scenario 'create a new reserve_fund' do
    Entity.make!(:detran)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    ReserveAllocationType.make!(:licitation)
    LicitationModality.make!(:publica)
    Creditor.make!(:nohup)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'

    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Reservado'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'
    fill_in 'Data', :with => '22/02/2012'
    fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
    fill_in 'Valor', :with => '10,00'
    fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
    fill_in 'Número da licitação', :with => '001/2012'
    fill_in 'Número do processo', :with => '002/2013'
    fill_modal 'Favorecido', :with => 'Nohup LTDA.'
    fill_in 'Histórico', :with => 'Historico da reserva'

    click_button 'Criar Reserva de Dotação'

    page.should have_notice 'Reserva de Dotação criado com sucesso.'

    click_link '2012'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_field  'Tipo', :with => 'Licitação'
    page.should have_field 'Data', :with => '22/02/2012'
    page.should have_field 'Dotação orçamentária', :with => "#{budget_allocation.id}/2012"
    page.should have_field 'Valor', :with => '10,00'
    page.should have_field 'Modalidade', :with => 'Pública'
    page.should have_field 'Número da licitação', :with => '001/2012'
    page.should have_field 'Número do processo', :with => '002/2013'
    page.should have_field 'Favorecido', :with => 'Nohup LTDA.'
    page.should have_field 'Histórico', :with => 'Historico da reserva'
  end

  scenario 'update an existent reserve_fund' do
    ReserveFund.make!(:detran_2012)
    Entity.make!(:secretaria_de_educacao)
    budget_allocation = BudgetAllocation.make!(:alocacao_extra)
    ReserveAllocationType.make!(:comum)
    Creditor.make!(:nobe)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link '2012'

    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Exercício', :with => '2011'
    fill_modal 'Tipo', :with => 'Comum', :field => 'Descrição'
    fill_in 'Data', :with => '23/02/2012'
    fill_modal 'Dotação orçamentária', :with => '2011', :field => 'Exercício'
    fill_in 'Valor', :with => '199,00'
    fill_in 'Número do processo', :with => '005/2015'
    fill_modal 'Favorecido', :with => 'Nobe'
    fill_in 'Histórico', :with => 'Novo histórico'

    click_button 'Atualizar Reserva de Dotação'

    page.should have_notice 'Reserva de Dotação editado com sucesso.'

    click_link '2011'

    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Exercício', :with => '2011'
    page.should have_field  'Tipo', :with => 'Comum'
    page.should have_field 'Data', :with => '23/02/2012'
    page.should have_field 'Dotação orçamentária', :with => "#{budget_allocation.id}/2011"
    page.should have_field 'Valor', :with => '199,00'
    page.should have_field 'Número do processo', :with => '005/2015'
    page.should have_field 'Favorecido', :with => 'Nobe'
    page.should have_field 'Histórico', :with => 'Novo histórico'
  end

  scenario 'destroy an existent reserve_fund' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    reserve_fund = ReserveFund.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link '2012'

    click_link "Apagar #{reserve_fund.id}/2012", :confirm => true

    page.should have_notice 'Reserva de Dotação apagado com sucesso.'

    page.should_not have_content '2012'
    page.should_not have_content 'Detran'
    page.should_not have_content "#{budget_allocation.id}/2012"
    page.should_not have_content '10,00'
  end

  scenario 'getting and cleaning budget_allocation amount via javascript' do
    budget_allocation = BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    page.should have_disabled_field 'Saldo orçamentário'

    fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'

    page.should have_disabled_field 'Saldo orçamentário'
    page.should have_field 'Saldo orçamentário', :with => '500,00'

    clear_modal 'Dotação orçamentária'

    page.should have_disabled_field 'Saldo orçamentário'
    page.should have_field 'Saldo orçamentário', :with => ''
  end

  scenario 'show modal info of budget allocation' do
    BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'

    click_link 'reserve_fund_budget_allocation_info_link'

    within '#record' do
      page.should have_content 'Detran'
      page.should have_content '2012'
      page.should have_content 'Alocação'
      page.should have_content '500,00'
    end
  end

  scenario 'enable/disable licitation and licitation modality fields depending on type' do
    ReserveAllocationType.make!(:licitation)
    ReserveAllocationType.make!(:comum)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Número da licitação'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'

    page.should_not have_disabled_field 'Modalidade'
    page.should_not have_disabled_field 'Número da licitação'

    clear_modal 'Tipo'

    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Número da licitação'

    fill_modal 'Tipo', :with => 'Comum', :field => 'Descrição'

    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Número da licitação'
  end
end
