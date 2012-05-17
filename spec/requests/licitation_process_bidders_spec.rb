# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessBidders" do
  background do
    sign_in
  end

  scenario 'accessing the bidders and return to licitation process edit page' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    bidder = licitation_process.licitation_process_bidders.first

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    page.should have_link bidder.to_s

    click_link 'Voltar ao processo licitatório'

    page.should have_content "Editar #{licitation_process.to_s}"
  end

  scenario 'creating a new bidder' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    Provider.make!(:sobrinho_sa)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    click_link 'Criar Licitante'

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Data do processo licitatório', :with => '20/03/2013'
    page.should have_field 'Processo administrativo', :with => '1/2013'

    fill_modal 'Fornecedor', :with => '123456', :field => 'Número do CRC'
    check 'Convidado'
    fill_in 'Protocolo', :with => '123456'
    fill_mask 'Data do protocolo', :with => I18n.l(Date.current)
    fill_mask 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    within_tab 'Documentos' do
      # testing that document type from licitation process are automaticaly included in bidder
      page.should have_disabled_field 'Documento'
      page.should have_field 'Documento', :with => 'Fiscal'

      fill_in 'Número/certidão', :with => '222222'
      fill_mask 'Data de emissão', :with => I18n.l(Date.tomorrow)
      fill_mask 'Validade', :with => I18n.l(Date.tomorrow + 5.days)
    end

    within_tab 'Propostas' do
      within_tab 'Itens' do
        page.should have_disabled_field 'Preço total dos itens'
        page.should have_disabled_field 'Material'
        page.should have_disabled_field 'Situação'
        page.should have_disabled_field 'Classificação'
        page.should have_disabled_field 'Unidade'
        page.should have_disabled_field 'Quantidade'
        page.should have_disabled_field 'Preço total'

        fill_in 'Marca', :with => 'Apple'
        fill_in 'Preço unitário', :with => '11,22'

        page.should have_field 'Preço total', :with => '22,44'
        page.should have_field 'Preço total dos itens', :with => '22,44'
      end
    end

    click_button 'Salvar'

    page.should have_content 'Licitante criado com sucesso.'

    within_records do
      click_link licitation_process.licitation_process_bidders.last.to_s
    end

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Data do processo licitatório', :with => '20/03/2013'
    page.should have_field 'Processo administrativo', :with => '1/2013'
    page.should have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
    page.should have_field 'Protocolo', :with => '123456'
    page.should have_field 'Data do protocolo', :with => I18n.l(Date.current)
    page.should have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    within_tab 'Documentos' do
      page.should have_field 'Documento', :with => 'Fiscal'
      page.should have_field 'Número/certidão', :with => '222222'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.tomorrow)
      page.should have_field 'Validade', :with => I18n.l(Date.tomorrow + 5.days)
    end

    within_tab 'Propostas' do
      within_tab 'Itens' do
        page.should have_disabled_field 'Preço total dos itens'
        page.should have_disabled_field 'Material'
        page.should have_disabled_field 'Situação'
        page.should have_disabled_field 'Classificação'
        page.should have_disabled_field 'Unidade'
        page.should have_disabled_field 'Quantidade'
        page.should have_disabled_field 'Preço total'

        page.should have_field 'Preço total dos itens', :with => '22,44'
        page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
        page.should have_field 'Situação', :with => ''
        page.should have_field 'Classificação', :with => ''
        page.should have_field 'Unidade', :with => 'Unidade'
        page.should have_field 'Quantidade', :with => '2'
        page.should have_field 'Preço unitário', :with => '11,22'
        page.should have_field 'Preço total', :with => '22,44'
        page.should have_field 'Marca', :with => 'Apple'
      end
    end
  end

  scenario 'updating an existing bidder' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    Provider.make!(:sobrinho_sa)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Data do processo licitatório', :with => '20/03/2013'
    page.should have_field 'Processo administrativo', :with => '1/2013'

    fill_modal 'Fornecedor', :with => '123456', :field => 'Número do CRC'
    check 'Convidado'
    fill_in 'Protocolo', :with => '111111'
    fill_mask 'Data do protocolo', :with => I18n.l(Date.tomorrow)
    fill_mask 'Data do recebimento', :with => I18n.l(Date.tomorrow + 1.day)

    within_tab 'Documentos' do
      fill_in 'Número/certidão', :with => '333333'
      fill_mask 'Data de emissão', :with => I18n.l(Date.tomorrow + 1.day)
      fill_mask 'Validade', :with => I18n.l(Date.tomorrow + 6.days)
    end

    within_tab 'Propostas' do
      within_tab 'Itens' do
        page.should have_disabled_field 'Preço total dos itens'
        page.should have_disabled_field 'Material'
        page.should have_disabled_field 'Situação'
        page.should have_disabled_field 'Classificação'
        page.should have_disabled_field 'Unidade'
        page.should have_disabled_field 'Quantidade'
        page.should have_disabled_field 'Preço total'

        fill_in 'Marca', :with => 'LG'
        fill_in 'Preço unitário', :with => '10,01'

        page.should have_field 'Preço unitário', :with => '10,01'
        page.should have_field 'Preço total', :with => '20,02'
      end
    end

    click_button 'Salvar'

    page.should have_content 'Licitante editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Data do processo licitatório', :with => '20/03/2013'
    page.should have_field 'Processo administrativo', :with => '1/2013'

    page.should have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
    page.should have_field 'Protocolo', :with => '111111'
    page.should have_field 'Data do protocolo', :with => I18n.l(Date.tomorrow)
    page.should have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow + 1.day)

    within_tab 'Documentos' do
      page.should have_field 'Documento', :with => 'Fiscal'
      page.should have_field 'Número/certidão', :with => '333333'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.tomorrow + 1.day)
      page.should have_field 'Validade', :with => I18n.l(Date.tomorrow + 6.days)
    end

    within_tab 'Propostas' do
      within_tab 'Itens' do
        page.should have_disabled_field 'Preço total dos itens'
        page.should have_disabled_field 'Material'
        page.should have_disabled_field 'Situação'
        page.should have_disabled_field 'Classificação'
        page.should have_disabled_field 'Unidade'
        page.should have_disabled_field 'Quantidade'
        page.should have_disabled_field 'Preço total'

        page.should have_field 'Preço total dos itens', :with => '20,02'
        page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
        page.should have_field 'Situação', :with => ''
        page.should have_field 'Classificação', :with => ''
        page.should have_field 'Unidade', :with => 'Unidade'
        page.should have_field 'Quantidade', :with => '2'
        page.should have_field 'Preço unitário', :with => '10,01'
        page.should have_field 'Preço total', :with => '20,02'
        page.should have_field 'Marca', :with => 'LG'
      end
    end
  end

  scenario 'deleting an bidder' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    bidder = licitation_process.licitation_process_bidders.first

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    page.should have_link bidder.to_s

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Licitante apagado com sucesso.'

    page.should_not have_link bidder.to_s
  end

  scenario 'when is not invited should disable and clear date, protocol fields' do
    LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Protocolo', :with => '123456'
    page.should have_field 'Data do protocolo', :with => I18n.l(Date.current)
    page.should have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    page.should_not have_disabled_field 'Protocolo'
    page.should_not have_disabled_field 'Data do protocolo'
    page.should_not have_disabled_field 'Data do recebimento'

    uncheck 'Convidado'

    page.should have_disabled_field 'Protocolo'
    page.should have_disabled_field 'Data do protocolo'
    page.should have_disabled_field 'Data do recebimento'

    page.should_not have_checked_field 'Convidado'
    page.should have_field 'Protocolo', :with => ''
    page.should have_field 'Data do protocolo', :with => ''
    page.should have_field 'Data do recebimento', :with => ''

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    page.should_not have_checked_field 'Convidado'
    page.should have_field 'Protocolo', :with => ''
    page.should have_field 'Data do protocolo', :with => ''
    page.should have_field 'Data do recebimento', :with => ''

    page.should have_disabled_field 'Protocolo'
    page.should have_disabled_field 'Data do protocolo'
    page.should have_disabled_field 'Data do recebimento'
  end

  scenario 'validating uniqueness of provider on licitation process scope' do
    LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    click_link 'Criar Licitante'

    fill_modal 'Fornecedor', :with => '456789', :field => 'Número do CRC'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end

  scenario 'creating some lots and showing one tab for lot on proposals' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_canetas)
    bidder = licitation_process.licitation_process_bidders.first

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'lote numero 1'
    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    page.should have_content 'Lote de itens criado com sucesso.'

    within_records do
      click_link licitation_process.licitation_process_lots.last.to_s
    end

    page.should have_field 'Observações', :with => 'lote numero 1'
    page.should have_content '01.01.00001 - Antivirus'
    page.should have_content '2'
    page.should have_content '10,00'

    click_link 'Cancelar'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'lote numero 2'
    fill_modal 'Itens', :with => '02.02.00002 - Arame comum', :field => 'Material'

    click_button 'Salvar'

    page.should have_content 'Lote de itens criado com sucesso.'

    within_records do
      click_link licitation_process.licitation_process_lots.last.to_s
    end

    page.should have_field 'Observações', :with => 'lote numero 2'
    page.should have_content '02.02.00002 - Arame comum'
    page.should have_content '1'
    page.should have_content '10,00'

    click_link 'Cancelar'

    page.should have_content 'lote numero 1'
    page.should have_content 'lote numero 2'

    click_link 'Voltar ao processo licitatório'

    click_link 'Licitantes'

    click_link bidder.to_s

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Data do processo licitatório', :with => '20/03/2013'
    page.should have_field 'Processo administrativo', :with => '1/2013'
    page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    page.should have_field 'Protocolo', :with => '123456'

    within_tab 'Propostas' do
      page.should have_content 'lote numero 1'
      page.should have_content 'lote numero 2'

      within_tab 'lote numero 1' do
        page.should have_disabled_field 'Preço total dos itens'
        page.should have_disabled_field 'Material'
        page.should have_disabled_field 'Situação'
        page.should have_disabled_field 'Classificação'
        page.should have_disabled_field 'Unidade'
        page.should have_disabled_field 'Quantidade'
        page.should have_disabled_field 'Preço total'

        page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
        page.should have_field 'Unidade', :with => 'Unidade'
        page.should have_field 'Quantidade', :with => '2'

        fill_in 'Marca', :with => 'mcafee'
        fill_in 'Preço unitário', :with => '99,99'

        page.should have_field 'Preço total', :with => '199,98'
        page.should have_field 'Preço total dos itens', :with => '199,98'
      end

      within_tab 'lote numero 2' do
        page.should have_disabled_field 'Preço total dos itens'
        page.should have_disabled_field 'Material'
        page.should have_disabled_field 'Situação'
        page.should have_disabled_field 'Classificação'
        page.should have_disabled_field 'Unidade'
        page.should have_disabled_field 'Quantidade'
        page.should have_disabled_field 'Preço total'

        page.should have_field 'Material', :with => '02.02.00002 - Arame comum'
        page.should have_field 'Unidade', :with => 'Unidade'
        page.should have_field 'Quantidade', :with => '1'

        fill_in 'Marca', :with => 'Arame Forte'
        fill_in 'Preço unitário', :with => '9,99'

        page.should have_field 'Preço total', :with => '9,99'
        page.should have_field 'Preço total dos itens', :with => '9,99'
      end
    end

    click_button 'Salvar'

    click_link bidder.to_s

    within_tab 'Propostas' do
      within_tab 'lote numero 1' do
        page.should have_disabled_field 'Preço total dos itens'
        page.should have_disabled_field 'Material'
        page.should have_disabled_field 'Situação'
        page.should have_disabled_field 'Classificação'
        page.should have_disabled_field 'Unidade'
        page.should have_disabled_field 'Quantidade'
        page.should have_disabled_field 'Preço total'

        page.should have_field 'Preço total dos itens', :with => '199,98'
        page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
        page.should have_field 'Situação', :with => ''
        page.should have_field 'Classificação', :with => ''
        page.should have_field 'Unidade', :with => 'Unidade'
        page.should have_field 'Quantidade', :with => '2'
        page.should have_field 'Preço unitário', :with => '99,99'
        page.should have_field 'Preço total', :with => '199,98'
        page.should have_field 'Marca', :with => 'mcafee'
      end

      within_tab 'lote numero 2' do
        page.should have_disabled_field 'Preço total dos itens'
        page.should have_disabled_field 'Material'
        page.should have_disabled_field 'Situação'
        page.should have_disabled_field 'Classificação'
        page.should have_disabled_field 'Unidade'
        page.should have_disabled_field 'Quantidade'
        page.should have_disabled_field 'Preço total'

        page.should have_field 'Preço total dos itens', :with => '9,99'
        page.should have_field 'Material', :with => '02.02.00002 - Arame comum'
        page.should have_field 'Situação', :with => ''
        page.should have_field 'Classificação', :with => ''
        page.should have_field 'Unidade', :with => 'Unidade'
        page.should have_field 'Quantidade', :with => '1'
        page.should have_field 'Preço unitário', :with => '9,99'
        page.should have_field 'Preço total', :with => '9,99'
        page.should have_field 'Marca', :with => 'Arame Forte'
      end
    end
  end

  scenario 'should show message that can not update proposals when any item does not have lot and licitation process has lot' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_canetas)
    bidder = licitation_process.licitation_process_bidders.first

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'lote numero 1'
    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    page.should have_content 'Lote de itens criado com sucesso.'

    within_records do
      click_link licitation_process.licitation_process_lots.last.to_s
    end

    page.should have_field 'Observações', :with => 'lote numero 1'
    page.should have_content '01.01.00001 - Antivirus'
    page.should have_content '2'
    page.should have_content '10,00'

    click_link 'Cancelar'

    page.should have_content 'lote numero 1'

    click_link 'Voltar ao processo licitatório'

    click_link 'Licitantes'

    click_link bidder.to_s

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Data do processo licitatório', :with => '20/03/2013'
    page.should have_field 'Processo administrativo', :with => '1/2013'
    page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    page.should have_field 'Protocolo', :with => '123456'

    within_tab 'Propostas' do
      page.should have_content 'Para adicionar propostas, todos os itens devem pertencer a algum Lote ou nenhum lote deve existir.'
    end
  end

  scenario 'submit button does show when envelope opening date is today' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    Provider.make!(:sobrinho_sa)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    click_link 'Criar Licitante'

    page.should have_button 'Salvar'
  end

  scenario 'submit button does not show when envelope opening date is not today' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    visit licitation_process_licitation_process_bidders_path(licitation_process)

    click_link 'Criar Licitante'

    page.should_not have_button 'Salvar'
  end
end
