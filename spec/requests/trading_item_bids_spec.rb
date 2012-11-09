# encoding: utf-8
require 'spec_helper'

feature "TradingItemBids" do
  background do
    sign_in
  end

  scenario "Placing an offer to an item" do
    Trading.make!(:pregao_presencial)

    navigate "Pregão Presencial > Pregões Presenciais"

    click_link "1/2012"

    click_link "Itens/Ofertas"

    click_link "Fazer oferta"

    expect(page).to have_content "Criar Oferta"

    expect(page).to have_field "Número da rodada", :with => "1"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Gabriel Sobrinho"
    expect(page).to have_disabled_field "Licitante"

    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_content "Oferta criada com sucesso"
  end

  scenario 'Increment bidder and round when all bidder have proposals' do
    sobrinho = Bidder.make!(:licitante_sobrinho)
    wenderson = Bidder.make!(:licitante)

    licitation_process = LicitationProcess.make!(:pregao_presencial,
      :bidders => [sobrinho, wenderson])

    trading = Trading.make!(:pregao_presencial,
                            :licitation_process => licitation_process)

    navigate "Pregão Presencial > Pregões Presenciais"

    click_link "1/2012"

    click_link "Itens/Ofertas"

    click_link "Fazer oferta"

    expect(page).to have_content "Criar Oferta"

    expect(page).to have_field "Número da rodada", :with => "1"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Gabriel Sobrinho"
    expect(page).to have_disabled_field "Licitante"

    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_content "Oferta criada com sucesso"

    click_link "Fazer oferta"

    expect(page).to have_content "Criar Oferta"

    expect(page).to have_field "Número da rodada", :with => "1"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Wenderson Malheiros"
    expect(page).to have_disabled_field "Licitante"

    fill_in "Valor da proposta", :with => "90,00"

    click_button "Salvar"

    expect(page).to have_content "Oferta criada com sucesso"

    click_link "Fazer oferta"

    expect(page).to have_content "Criar Oferta"

    expect(page).to have_field "Número da rodada", :with => "2"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Gabriel Sobrinho"
    expect(page).to have_disabled_field "Licitante"
  end

  scenario 'when form is with errors back button should back to the trading_items index' do
    Trading.make!(:pregao_presencial)

    navigate 'Pregão Presencial > Pregões Presenciais'

    click_link '1/2012'

    click_link 'Itens/Ofertas'

    click_link 'Fazer oferta'

    expect(page).to have_content "Criar Oferta"

    click_button 'Salvar'

    expect(page).to have_content 'não pode ficar em branco'

    click_button 'Salvar'

    expect(page).to have_content 'não pode ficar em branco'

    click_link 'Voltar'

    expect(page).to have_content 'Itens do Pregão Presencial 1/2012'
  end
end
