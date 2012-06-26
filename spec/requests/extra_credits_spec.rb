# encoding: utf-8
require 'spec_helper'

feature "ExtraCredits" do
  background do
    sign_in
  end

  scenario 'create a new extra_credit' do
    Descriptor.make!(:detran_2012)
    RegulatoryAct.make!(:sopa)
    ExtraCreditNature.make!(:abre_credito)
    MovimentType.make!(:adicionar_dotacao)
    MovimentType.make!(:subtrair_do_excesso_arrecadado)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Capability.make!(:reforma)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      select 'Especial', :from => 'Tipo de crédito'
      fill_modal 'Natureza de crédito', :with => 'Abre crédito suplementar', :field => 'Descrição'
      fill_in 'Data crédito', :with => '01/03/2012'
    end

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Adicionar dotação'
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_in 'Valor', :with => '10,00'
      end

      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
        fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
        fill_in 'Valor', :with => '10,00'
      end

      page.should have_disabled_field 'Suplementado'
      page.should have_field 'Suplementado', :with => '10,00'

      page.should have_disabled_field 'Reduzido'
      page.should have_field 'Reduzido', :with => '10,00'

      page.should have_disabled_field 'Diferença'
      page.should have_field 'Diferença', :with => '0,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Crédito Suplementar criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Descritor', :with => '2012 - Detran'
      page.should have_select 'Tipo de crédito', :selected => 'Especial'
      page.should have_field 'Ato regulamentador', :with => '1234'
      page.should have_field 'Tipo de ato regulamentador', :with => 'Lei'
      page.should have_field 'Data de publicação', :with => '02/01/2012'
      page.should have_field 'Natureza de crédito', :with => 'Abre crédito suplementar'
      page.should have_field 'Classificação da natureza de crédito', :with => 'Outros'
      page.should have_field 'Data crédito', :with => '01/03/2012'
    end

    within_tab 'Movimentos' do
      within 'fieldset:last' do
        page.should have_field 'Tipo de movimento', :with => 'Adicionar dotação'
        page.should have_field 'Dotação', :with => budget_allocation.to_s
        page.should have_disabled_field 'Recurso'
        page.should have_field 'Valor', :with => '10,00'
      end

      within 'fieldset:first' do
        page.should have_field 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
        page.should have_disabled_field 'Dotação'
        page.should have_field 'Recurso', :with => 'Reforma e Ampliação'
        page.should have_field 'Valor', :with => '10,00'
      end

      page.should have_disabled_field 'Suplementado'
      page.should have_field 'Suplementado', :with => '10,00'

      page.should have_disabled_field 'Reduzido'
      page.should have_field 'Reduzido', :with => '10,00'

      page.should have_disabled_field 'Diferença'
      page.should have_field 'Diferença', :with => '0,00'
    end
  end

  scenario 'calculate suplement and reduced' do
    MovimentType.make!(:adicionar_dotacao)
    MovimentType.make!(:subtrair_do_excesso_arrecadado)
    BudgetAllocation.make!(:alocacao)
    Capability.make!(:reforma)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Adicionar dotação'

        ignoring_scopes do
          # bugfix: avoid NaN error
          page.should have_field 'Suplementado', :with => '0,00'
          page.should have_field 'Diferença', :with => '0,00'
        end

        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_in 'Valor', :with => '10,00'
      end

      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'

        ignoring_scopes do
          # bugfix: avoid NaN error
          page.should have_field 'Reduzido', :with => '0,00'
          page.should have_field 'Diferença', :with => '10,00'
        end

        fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
        fill_in 'Valor', :with => '10,00'
      end

      page.should have_disabled_field 'Suplementado'
      page.should have_field 'Suplementado', :with => '10,00'

      page.should have_disabled_field 'Reduzido'
      page.should have_field 'Reduzido', :with => '10,00'

      page.should have_disabled_field 'Diferença'
      page.should have_field 'Diferença', :with => '0,00'
    end
  end

  scenario 'when operation is subtraction and budget_allocation used item value should not be greater than budget allocation real_amount' do
    MovimentType.make!(:subtrair_dotacao)
    MovimentType.make!(:adicionar_em_outros_casos)
    BudgetAllocation.make!(:alocacao)
    Capability.make!(:reforma)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Subtrair dotação'
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_in 'Valor', :with => '501,00'
      end

      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Adicionar em outros casos'
        fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
        fill_in 'Valor', :with => '10,00'
      end
    end

    click_button 'Salvar'

    within_tab 'Movimentos' do
      page.should have_content 'não pode ser maior que o saldo real da dotação (R$ 489,50)'
    end
  end

  scenario 'when fill administractive act should fill regulatory_act_type and publication_date too' do
    RegulatoryAct.make!(:sopa)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    page.should have_field 'Tipo de ato regulamentador', :with => 'Lei'
    page.should have_field 'Data de publicação', :with => '02/01/2012'
  end

  scenario 'when fill additional credit opening should fill kind too' do
    ExtraCreditNature.make!(:abre_credito)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    fill_modal 'Natureza de crédito', :with => 'Abre crédito suplementar', :field => 'Descrição'

    page.should have_field 'Classificação da natureza de crédito', :with => 'Outros'
  end

  context 'should have modal link' do
    scenario 'when already stored' do
      extra_credit = ExtraCredit.make!(:detran_2012)

      navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link "#{extra_credit.id}"

      within_tab 'Movimentos' do
        within 'fieldset:first' do
          click_link 'Mais informações'
        end
      end

      page.should have_content 'Informações de: Alocação'
    end

    scenario 'when change budget_allocation' do
      extra_credit = ExtraCredit.make!(:detran_2012)
      BudgetAllocation.make!(:alocacao_extra)

      navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link extra_credit.to_s

      within_tab 'Movimentos' do
        within 'fieldset:first' do
          click_link 'Mais informações'
        end
      end

      page.should have_content 'Informações de: Alocação'
    end

    scenario 'when add a new record' do
      MovimentType.make!(:adicionar_dotacao)
      BudgetAllocation.make!(:alocacao_extra)

      navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link 'Criar Crédito Suplementar'

      within_tab 'Movimentos' do
        click_button 'Adicionar Movimento'

        within 'fieldset:first' do
          fill_modal 'Tipo de movimento', :with => 'Adicionar dotação'
          fill_modal 'Dotação', :with => '1', :field => 'Código'

          click_link 'Mais informações'
        end
      end

      page.should have_content 'Informações de: Alocação extra'
    end
  end

  context 'should have modal link to capability' do
    scenario 'when already stored' do
      extra_credit = ExtraCredit.make!(:detran_2012)

      navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link extra_credit.to_s

      within_tab 'Movimentos' do
        within 'fieldset:last' do
          within '.capability-field' do
            click_link 'Mais informações'
          end
        end
      end

      page.should have_content 'Informações de: Reforma e Ampliação'
    end

    scenario 'when change' do
      extra_credit = ExtraCredit.make!(:detran_2012)
      Capability.make!(:construcao)

      navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link extra_credit.to_s

      within_tab 'Movimentos' do
        within 'fieldset:last' do
          fill_modal 'Recurso', :with => 'Construção', :field => 'Descrição'

          within '.capability-field' do
            click_link 'Mais informações'
          end
        end
      end

      page.should have_content 'Informações de: Construção'
    end

    scenario 'when add a new record' do
      MovimentType.make!(:subtrair_do_excesso_arrecadado)
      Capability.make!(:construcao)

      navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link 'Criar Crédito Suplementar'

      within_tab 'Movimentos' do
        click_button 'Adicionar Movimento'

        within 'fieldset:first' do
          fill_modal 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
          fill_modal 'Recurso', :with => 'Construção', :field => 'Descrição'

          within '.capability-field' do
            click_link 'Mais informações'
          end
        end
      end

      page.should have_content 'Informações de: Construção'
    end
  end

  scenario 'remove extra_credit_moviment_type' do
    extra_credit = ExtraCredit.make!(:detran_2012)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link extra_credit.to_s

    within_tab 'Movimentos' do
      click_button 'Remover Movimento'
      click_button 'Remover Movimento'
    end

    click_button 'Salvar'

    click_link extra_credit.to_s

    within_tab 'Movimentos' do
      page.should_not have_field 'Tipo de movimento'
      page.should_not have_field 'Dotação'
      page.should_not have_field 'Recurso'
      page.should_not have_field 'Valor'
    end
  end

  scenario 'update an existent extra_credit' do
    Descriptor.make!(:secretaria_de_educacao_2011)
    RegulatoryAct.make!(:emenda)
    extra_credit = ExtraCredit.make!(:detran_2012)
    ExtraCreditNature.make!(:abre_credito_de_transferencia)
    MovimentType.make!(:subtrair_do_excesso_arrecadado)
    Capability.make!(:reforma)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link extra_credit.to_s

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
      fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
      select 'Suplementar', :from => 'Tipo de crédito'
      fill_modal 'Natureza de crédito', :with => 'Abre crédito suplementar de transferência', :field => 'Descrição'
      fill_in 'Data crédito', :with => '21/03/2012'
    end

    within_tab 'Movimentos' do
      within 'fieldset:first' do
        fill_in 'Valor', :with => '20,00'
      end

      within 'fieldset:last' do
        fill_in 'Valor', :with => '20,00'
      end
    end

    click_button 'Salvar'

    page.should have_notice 'Crédito Suplementar editado com sucesso.'

    click_link extra_credit.to_s

    within_tab 'Principal' do
      page.should have_field 'Descritor', :with => '2011 - Secretaria de Educação'
      page.should have_select 'Tipo de crédito', :selected => 'Suplementar'
      page.should have_field 'Ato regulamentador', :with => '4567'
      page.should have_field 'Tipo de ato regulamentador', :with => 'Emenda constitucional'
      page.should have_field 'Natureza de crédito', :with => 'Abre crédito suplementar de transferência'
      page.should have_field 'Classificação da natureza de crédito', :with => 'Transferência'
      page.should have_field 'Data de publicação', :with => '02/01/2012'
      page.should have_field 'Data crédito', :with => '21/03/2012'
    end

    within_tab 'Movimentos' do
      within 'fieldset:first' do
        page.should have_field 'Valor', :with => '20,00'
      end

      within 'fieldset:first' do
        page.should have_field 'Valor', :with => '20,00'
      end
    end
  end

  scenario 'validate uniqueness of budget_allocation' do
    BudgetAllocation.make!(:alocacao)
    extra_credit = ExtraCredit.make!(:detran_2012)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link extra_credit.to_s

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:last' do
        fill_modal 'Tipo de movimento', :with => 'Adicionar dotação'
        fill_modal 'Dotação', :with => '1', :field => 'Código'
      end
    end

    click_button 'Salvar'

    within_tab 'Movimentos' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'validate uniqueness of capibality' do
    BudgetAllocation.make!(:alocacao)
    extra_credit = ExtraCredit.make!(:detran_2012)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link extra_credit.to_s

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
        fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      end
    end

    click_button 'Salvar'

    within_tab 'Movimentos' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'validate uniqueness of administractive act' do
    ExtraCredit.make!(:detran_2012)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    click_button 'Salvar'

    page.should have_content 'já utilizado em outro crédito suplementar'
  end

  scenario 'destroy an existent extra_credit' do
    extra_credit = ExtraCredit.make!(:detran_2012)

    navigate_through 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link extra_credit.to_s

    click_link "Apagar", :confirm => true

    page.should have_notice 'Crédito Suplementar apagado com sucesso.'

    page.should_not have_content 'Detran'
    page.should_not have_content '2012'
    page.should_not have_content 'Especial'
  end
end
