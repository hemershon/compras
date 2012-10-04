# encoding: utf-8
require 'spec_helper'

feature 'DirectPurchaseAnnuls' do
  background do
    sign_in
  end

  scenario 'annul link should not be visible on create a direct purchase' do
    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Gerar Compra Direta'

    expect(page).to_not have_link 'Anular'
  end

  scenario 'annul link should be visible on update direct purchase' do
    DirectPurchase.make!(:compra)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    expect(page).to have_link 'Anular'
  end

  scenario 'should not be possible to save or generate supply_authorizarion when annulded' do
    ResourceAnnul.make!(
      :anulacao_generica,
      :annullable => DirectPurchase.make!(:compra)
    )

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_link 'Anular'
    expect(page).to_not have_link 'Salvar'
    expect(page).to_not have_button 'Gerar autorização de fornecimento'
  end

  scenario 'should not be possible to send supply_authorizarion by email when annulled' do
    supply_authorization = SupplyAuthorization.make!(:nohup)

    ResourceAnnul.make!(
      :anulacao_generica,
      :annullable => supply_authorization.direct_purchase
    )

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_link 'Anular'
    expect(page).to_not have_link 'Salvar'
    expect(page).to_not have_button 'Enviar autorização de fornecimento por e-mail'
  end

  scenario 'annul an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    click_link 'Anular'

    expect(page).to have_content "Anular Gerar Compra Direta 1/2012"

    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_in 'Data', :with => '01/10/2012'
    fill_in 'Justificativa', :with => 'Anulação da compra direta'

    click_button 'Salvar'

    expect(page).to have_notice 'Anulação de Recurso criado com sucesso.'

    click_link 'Anulação'

    expect(page).to have_content "Anulação da Gerar Compra Direta 1/2012"

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data', :with => '01/10/2012'
    expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'
  end

  scenario 'annul an existent direct_purchase with purchase_solicitation_item_group' do
    DirectPurchase.make!(
      :compra,
      :purchase_solicitation_item_group => PurchaseSolicitationItemGroup.make!(:antivirus)
    )

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    click_link 'Anular'

    expect(page).to have_content "Anular Gerar Compra Direta 1/2012"

    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_in 'Data', :with => '01/10/2012'
    fill_in 'Justificativa', :with => 'Anulação da compra direta'

    click_button 'Salvar'

    expect(page).to have_notice 'Anulação de Recurso criado com sucesso.'

    click_link 'Anulação'

    expect(page).to have_content "Anulação da Gerar Compra Direta 1/2012"

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data', :with => '01/10/2012'
    expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'

    navigate 'Compras e Licitações > Cadastros Gerais > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Agrupamento de antivirus'

    click_link 'Anulação'

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data', :with => '01/10/2012'
    expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'
  end

  scenario 'annul an existent direct_purchase with purchase_solicitation' do
    DirectPurchase.make!(
      :compra,
      :purchase_solicitation => PurchaseSolicitation.make!(:reparo)
    )

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    click_link 'Anular'

    expect(page).to have_content "Anular Gerar Compra Direta 1/2012"

    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_in 'Data', :with => '01/10/2012'
    fill_in 'Justificativa', :with => 'Anulação da compra direta'

    click_button 'Salvar'

    expect(page).to have_notice 'Anulação de Recurso criado com sucesso.'

    click_link 'Anulação'

    expect(page).to have_content "Anulação da Gerar Compra Direta 1/2012"

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data', :with => '01/10/2012'
    expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'

    navigate 'Compras e Licitações > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Pendente'
    end

    within_tab 'Dotações orçamentarias' do
      within '.purchase-solicitation-budget-allocation:first' do
        within '.item:first' do
          expect(page).to have_select 'Status', :selected => 'Pendente'
          expect(page).to have_field 'Atendido por', :with => ''
        end
      end
    end
  end

  scenario 'annul an existent direct_purchase with purchase_solicitation and supply_authorization' do
    SupplyAuthorization.make!(
      :nohup,
      :direct_purchase => DirectPurchase.make!(
        :compra,
        :purchase_solicitation => PurchaseSolicitation.make!(:reparo)
      )
    )

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    click_link 'Anular'

    expect(page).to have_content "Anular Gerar Compra Direta 1/2012"

    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_in 'Data', :with => '01/10/2012'
    fill_in 'Justificativa', :with => 'Anulação da compra direta'

    click_button 'Salvar'

    expect(page).to have_notice 'Anulação de Recurso criado com sucesso.'

    click_link 'Anulação'

    expect(page).to have_content "Anulação da Gerar Compra Direta 1/2012"

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data', :with => '01/10/2012'
    expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'

    navigate 'Compras e Licitações > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Liberada'
    end

    within_tab 'Dotações orçamentarias' do
      within '.purchase-solicitation-budget-allocation:first' do
        within '.item:first' do
          expect(page).to have_select 'Status', :selected => 'Pendente'
          expect(page).to have_field 'Atendido por', :with => ''
        end
      end
    end
  end

  scenario 'when annul a direct purchase the licitation object balance should be rolled back' do
    direct_purchase = DirectPurchase.make!(:compra)
    DirectPurchase.make!(:compra_nao_autorizada)
    DirectPurchase.make!(:compra_2011)

    navigate 'Compras e Licitações > Cadastros Gerais > Objetos de Licitação'

    click_link 'Ponte'

    within_tab 'Total acumulado' do
      within_fieldset 'Total acumulado de compras e serviços' do
        expect(page).to have_field 'Dispensa de licitação', :with => '1.200,00'
      end

      within_fieldset 'Total acumulado de obras e engenharia' do
        expect(page).to have_field 'Dispensa de licitação', :with => '600,00'
      end
    end

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      click_link "#{direct_purchase}"
    end

    click_link 'Anular'

    expect(page).to have_content "Anular Gerar Compra Direta 1/2012"

    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_in 'Data', :with => '01/10/2012'
    fill_in 'Justificativa', :with => 'Anulação da compra direta'

    click_button 'Salvar'

    expect(page).to have_notice 'Anulação de Recurso criado com sucesso.'

    click_link 'Anulação'

    expect(page).to have_content "Anulação da Gerar Compra Direta 1/2012"

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data', :with => '01/10/2012'
    expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'

    navigate 'Compras e Licitações > Cadastros Gerais > Objetos de Licitação'

    click_link 'Ponte'

    within_tab 'Total acumulado' do
      within_fieldset 'Total acumulado de compras e serviços' do
        expect(page).to have_field 'Dispensa de licitação', :with => '600,00'
      end

      within_fieldset 'Total acumulado de obras e engenharia' do
        expect(page).to have_field 'Dispensa de licitação', :with => '600,00'
      end
    end
  end
end
