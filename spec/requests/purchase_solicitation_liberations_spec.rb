# encoding: utf-8
require 'spec_helper'

feature "PurchaseSolicitationLiberations" do
  let(:current_user) { User.make!(:sobrinho) }

  let :budget_structure do
    BudgetStructure.new(
      id: 1,
      code: '1',
      full_code: '1',
      tce_code: '051',
      description: 'Secretaria de Educação',
      acronym: 'SEMUEDU',
      performance_field: 'Desenvolvimento Educacional')
  end

  background do
    BudgetStructure.stub(:find).with(1).and_return(budget_structure)

    create_roles ['purchase_solicitations', 'employees']
    sign_in

    ExpenseNature.stub(:all)
    ExpenseNature.stub(:find)
  end

  scenario 'create a new purchase_solicitation_liberation' do
    PurchaseSolicitation.make!(:reparo)
    Employee.make!(:wenderson)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Status de atendimento', :selected => 'Pendente'

    # button liberate can be seen when purchase_solicitation is pending
    click_link 'Liberações'

    expect(page).to have_content 'Liberações da Solicitação de Compra 1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'

    click_link 'Criar Liberação de Solicitação de Compra'

    expect(page).to_not have_disabled_field 'Responsável'

    expect(page).to have_content 'Criar Liberação para a Solicitação de Compra 1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'

    expect(page).to have_field 'Data', :with => I18n.l(Date.current)
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    fill_modal 'Responsável', :field => 'Matrícula', :with => '12903412'
    fill_in 'Justificativa', :with => 'Compra justificada'

    select 'Liberada', :from => 'Status de atendimento'

    click_button 'Salvar'

    expect(page).to have_notice 'Solicitação de Compras liberada com sucesso'

    click_link 'Voltar para a Solicitação de Compra'

    expect(page).to have_select 'Status de atendimento', :selected => 'Liberada'

    click_link 'Liberações'

    within_records do
      expect(page).to have_content 'Sequência'
      expect(page).to have_content 'Responsável'
      expect(page).to have_content 'Data'
      expect(page).to have_content 'Status de atendimento'

      within 'tbody tr' do
        expect(page).to have_content '1'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content I18n.l(Date.current)
        expect(page).to have_content 'Liberada'
      end
    end

    expect(page).to_not have_link 'Criar Liberação de Solicitação de Compra'

    within_records do
      page.find('a').click
    end

    expect(page).to have_disabled_field 'Justificativa'
    expect(page).to have_disabled_field 'Data'
    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_disabled_field 'Status de atendimento'

    expect(page).to have_content 'Editar Liberação 1 da Solicitação de Compra 1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
    expect(page).to have_field 'Justificativa', :with => 'Compra justificada'
    expect(page).to have_field 'Data', :with => I18n.l(Date.current)
    expect(page).to have_field 'Responsável', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Sequência', :with => '1'
  end
end
