#encoding: utf-8
require 'spec_helper'

feature 'PurchaseSolicitationAnnul' do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  let :budget_structure do
    BudgetStructure.new(
      id: 1,
      code: '1',
      full_code: '1',
      tce_code: '051',
      description: 'Secretaria de Desenvolvimento',
      acronym: 'SEMUEDU',
      performance_field: 'Desenvolvimento Educacional')
  end

  background do
    sign_in

    BudgetStructure.stub(:find).with(1).and_return(budget_structure)

    ExpenseNature.stub(:all)
    ExpenseNature.stub(:find)
  end

  scenario 'should not have a annul link when was creating a new solicitation' do
    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    expect(page).to_not have_link 'Anular'
    expect(page).to_not have_link 'Anulação'
  end

  scenario 'should see the default values on the screen' do
    solicitation = PurchaseSolicitation.make!(:reparo)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    click_link "#{solicitation.decorator.code_and_year}"

    click_link 'Anular'

    expect(page).to have_content "Anular Solicitação de Compra #{solicitation}"

    expect(page).to have_field 'Data', :with => I18n.l(Date.current)
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    expect(page).to have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end

  scenario 'annul button should be disabled when there is a direct_purchase related' do
    purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)
    LicitationProcess.make!(:processo_licitatorio, purchase_solicitations: [purchase_solicitation])

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    click_link "#{purchase_solicitation.decorator.code_and_year}"

    expect(page).to have_disabled_element 'Anular',
                                          :reason => 'está sendo utilizada no processo de compra, não pode ser anulada.'
  end

  scenario 'annuling a purchase solicitation' do
    solicitation = PurchaseSolicitation.make!(:reparo)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    click_link "#{solicitation.decorator.code_and_year}"

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'

      click_record 'Gabriel Sobrinho'
    end

    fill_in 'Data', :with => '10/06/2012'
    fill_in 'Justificativa', :with => 'Foo Bar'

    click_button 'Salvar'

    expect(page).to have_content 'Anulação de Recurso criada com sucesso.'

    expect(page).to have_title "Editar Solicitação de Compra"
    expect(page).to have_select 'Status de atendimento', :selected => 'Anulada'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Ano'
      expect(page).to have_disabled_field 'Data da solicitação'
      expect(page).to have_disabled_field 'Solicitante'
      expect(page).to have_disabled_field 'Responsável pela solicitação'
      expect(page).to have_disabled_field 'Justificativa da solicitação'
      expect(page).to have_disabled_field 'Local para entrega'
      expect(page).to have_disabled_field 'Tipo de solicitação'
      expect(page).to have_disabled_field 'Observações gerais'
      expect(page).to have_disabled_field 'Status de atendimento'
      expect(page).to have_disabled_field 'Liberação'
      expect(page).to have_disabled_field 'Por'
      expect(page).to have_disabled_field 'Observações do atendimento'
      expect(page).to have_disabled_field 'Justificativa para não atendimento'
    end

    within_tab 'Itens' do
      expect(page).to have_disabled_field 'Valor total dos itens'
    end

    within_tab 'Itens' do
      expect(page).to have_disabled_element 'Adicionar',
                      :reason => 'esta solicitação foi anulada e não pode ser editada'

      within_records do
        expect(page).to have_disabled_element 'Remover',
                        :reason => 'esta solicitação foi anulada e não pode ser editada'
      end
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_disabled_field 'Dotação'

      within_records do
        expect(page).to have_disabled_element 'Remover',
                    :reason => 'esta solicitação foi anulada e não pode ser editada'
      end
    end

    expect(page).to have_disabled_element 'Salvar',
                    :reason => 'esta solicitação já está em uso ou anulada e não pode ser editada'

    click_link 'Anulação'

    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Data', :with => '10/06/2012'

    expect(page).to have_disabled_field 'Justificativa'
    expect(page).to have_field 'Justificativa', :with => 'Foo Bar'

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end
end
