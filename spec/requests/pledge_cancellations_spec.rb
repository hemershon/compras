# encoding: utf-8
require 'spec_helper'

feature "PledgeCancellations" do
  background do
    Pledge.destroy_all
    PledgeExpiration.destroy_all
    sign_in
  end

  scenario 'create a new pledge_cancellation' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    fill_modal 'Parcela', :with => '1', :field => 'Número'
    fill_in 'Valor *', :with => '1,00'
    select 'Parcial', :from => 'Tipo de anulação'
    fill_in 'Data *', :with => I18n.l(Date.current + 1.day)
    select 'Normal', :from => 'Natureza da ocorrência'
    fill_in 'Motivo', :with => 'Motivo para o anulamento'

    click_button 'Criar Anulação de Empenho'

    page.should have_notice 'Anulação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'

    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Valor anulado'
    page.should have_field 'Valor anulado', :with => '1,00'

    page.should have_field 'Valor *', :with => '1,00'
    page.should have_select 'Tipo de anulação', :selected => 'Parcial'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_select 'Natureza da ocorrência', :selected => 'Normal'
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'when fill pledge and pledge_expiration should fill delegateds fields' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Valor anulado'
    page.should have_field 'Valor anulado', :with => '0,00'
  end

  scenario 'should fill date when date is greater than last' do
    Pledge.make!(:empenho_em_quinze_dias)
    PledgeCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => I18n.l(Date.current + 15.days), :field => 'Data de emissão'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 15.days)
  end

  scenario 'should not fill when date is not greater than last' do
    Pledge.make!(:empenho)
    PledgeCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => I18n.l(Date.current), :field => 'Data de emissão'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.days)
  end

  scenario 'should not fill when date is already changed' do
    Pledge.make!(:empenho_em_quinze_dias)
    PledgeCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_in 'Data *', :with => I18n.l(Date.current - 10.days)
    fill_modal 'Empenho', :with => I18n.l(Date.current + 15.days), :field => 'Data de emissão'
    page.should have_field 'Data *', :with => I18n.l(Date.current - 10.days)
  end

  scenario 'clear pledge and pledge_expiration when clear pledge' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    page.should have_field 'Parcela', :with => '1'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Valor anulado', :with => '0,00'

    clear_modal 'Empenho'
    page.should have_field 'Empenho', :with => ''
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => ''
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => ''

    page.should have_field 'Parcela', :with => ''
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => ''
    page.should have_disabled_field 'Valor anulado'
    page.should have_field 'Valor anulado', :with => ''
  end

  scenario 'when select total as kind should disabled and fill value' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    select 'Total', :from => 'Tipo de anulação'

    page.should have_disabled_field 'Valor *'
    page.should have_field 'Valor *', :with => '100,00'
  end

  scenario 'should fill value when select pledge_expiration before kind and kind is total' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    select 'Total', :from => 'Tipo de anulação'
    fill_modal 'Parcela', :with => '1', :field => 'Número'

    page.should have_disabled_field 'Valor *'
    page.should have_field 'Valor *', :with => '100,00'
  end

  scenario 'when select pledge_expiration first fill pledge' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    page.should have_field 'Parcela', :with => '1'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Valor anulado', :with => '0,00'

    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_field 'Valor do empenho', :with => '9,99'
  end

  scenario 'when select pledge first should filter pledge_expiration by pledge_id' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    fill_modal 'Parcela', :with => '1', :field => 'Número' do
      page.should have_disabled_field 'filter_pledge'
      page.should have_field 'filter_pledge', :with => "#{pledge.id}"
    end
  end

  scenario 'when select pledge first and clear it should clear filter by pledge on pledge_expiration modal' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    clear_modal 'Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número' do
      page.should_not have_disabled_field 'filter_pledge'
      page.should have_field 'filter_pledge', :with => ''
    end
  end

  scenario 'should have all fields disabled when editing an existent pledge' do
    pledge = Pledge.make!(:empenho)
    PledgeCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    within_records do
      page.find('a').click
    end

    should_not have_button 'Criar Anulação de Empenho'

    page.should have_disabled_field 'Empenho'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'
    page.should have_disabled_field 'Parcela'
    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Valor anulado'
    page.should have_field 'Valor anulado', :with => '1,00'
    page.should have_disabled_field 'Valor *'
    page.should have_field 'Valor *', :with => '1,00'
    page.should have_disabled_field 'Tipo de anulação'
    page.should have_select 'Tipo de anulação', :selected => 'Parcial'
    page.should have_disabled_field 'Data *'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Natureza da ocorrência'
    page.should have_select 'Natureza da ocorrência', :selected => 'Normal'
    page.should have_disabled_field 'Motivo'
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'should not have a button to destroy an existent pledge' do
    pledge_cancellation = PledgeCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    within_records do
      page.find('a').click
    end

    page.should_not have_link "Apagar #{pledge_cancellation.id}"
  end
end
