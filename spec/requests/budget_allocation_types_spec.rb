# encoding: utf-8
require 'spec_helper'

feature "BudgetAllocationTypes" do
  background do
    sign_in
  end

  scenario 'create a new budget_allocation_type' do
    navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Tipos de Dotação'

    click_link 'Criar Tipo de Dotação'

    fill_in 'Descrição', :with => 'Administrativa'
    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Dotação criado com sucesso.'

    click_link 'Administrativa'

    expect(page).to have_field 'Descrição', :with => 'Administrativa'
    expect(page).to have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent budget_allocation_type' do
    BudgetAllocationType.make!(:administrativa)

    navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Tipos de Dotação'

    click_link 'Administrativa'

    fill_in 'Descrição', :with => 'Executiva'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Dotação editado com sucesso.'

    click_link 'Executiva'

    expect(page).to have_field 'Descrição', :with => 'Executiva'
    expect(page).to have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent budget_allocation_type' do
    BudgetAllocationType.make!(:administrativa)

    navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Tipos de Dotação'

    click_link 'Dotação Administrativa'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Tipo de Dotação apagado com sucesso.'

    expect(page).not_to have_content 'Administrativation'
  end

  scenario 'validate uniqueness of description' do
    BudgetAllocationType.make!(:administrativa)

    navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Tipos de Dotação'

    click_link 'Criar Tipo de Dotação'

    fill_in 'Descrição', :with => 'Dotação Administrativa'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end
end
