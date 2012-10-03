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

    page.driver.render('tmp/imgage.png', :full => true)
    click_link 'Anulação'

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data', :with => '01/10/2012'
    expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'
  end
end