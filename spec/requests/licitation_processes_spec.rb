# encoding: utf-8
require 'spec_helper'

feature "LicitationProcesses" do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    create_roles ['judgment_forms',
                  'payment_methods',
                  'indexers',
                  'capabilities',
                  'document_types',
                  'materials',
                  'licitation_process_publications',
                  'purchase_solicitations',
                  'delivery_locations']
    sign_in
  end

  scenario 'create a new licitation_process' do
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    expect(page).to have_content "Criar Processo"

    expect(page).to_not have_link 'Publicações'

    expect(page).to_not have_button 'Apurar'

    expect(page).to have_disabled_field 'Status'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'
      expect(page).to have_disabled_field 'Modalidade'
      expect(page).to have_disabled_field 'Data da homologação'
      expect(page).to have_disabled_field 'Data da adjudicação'
      expect(page).to have_disabled_field 'Data da abertura dos envelopes'
      expect(page).to have_disabled_field 'Hora da abertura'

      choose 'Processo licitatório'
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da expedição', :with => '21/03/2012'
      select 'Global', :from => 'Tipo de empenho'

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'
      select 'Por Item com Melhor Técnica', :from =>'Forma de julgamento'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Inciso', :with => 'Item 1'

      check 'Registro de preço'
      select 'Menor preço total por item', :from => 'Tipo da apuração'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => '14:00'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Alocação'

      fill_in 'Valor previsto', :with => '20,00'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Quantidade', :with => '2'
      fill_in 'Valor unitário máximo', :with => '10,00'

      # asserting calculated total price of the item
      expect(page).to have_field 'Valor total', :with => '20,00'
    end

    within_tab 'Configuração da apuração' do
      check 'Desclassificar participantes com problemas da documentação'
      check 'Desclassificar participantes com cotações acima do valor máximo estabelecido no edital'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 criado com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'
      expect(page).to have_disabled_field 'Ano'

      expect(page).to have_field 'Processo', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da expedição', :with => '21/03/2012'
      expect(page).to have_select 'Tipo de empenho', :selected => 'Global'
      expect(page).to_not have_disabled_field 'Data da abertura dos envelopes'
      expect(page).to_not have_disabled_field 'Hora da abertura'

      expect(page).to have_select 'Modalidade', :selected => 'Concorrência'
      expect(page).to have_select 'Tipo de objeto', :selected => 'Compras e serviços'
      expect(page).to have_select 'Forma de julgamento', :selected => 'Por Item com Melhor Técnica'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Inciso', :with => 'Item 1'

      expect(page).to have_select 'Tipo da apuração', :selected => 'Menor preço total por item'
      expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
      expect(page).to have_select 'Tipo de garantia', :selected => 'Fiança bancária'
      expect(page).to have_field 'Fonte de recurso', :with => 'Reforma e Ampliação'
      expect(page).to have_field 'Validade da proposta', :with => '5'
      expect(page).to have_select 'Período da validade da proposta', :selected => 'dia/dias'
      expect(page).to have_field 'Índice de reajuste', :with => 'XPTO'
      expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      expect(page).to have_field 'Hora da entrega', :with => '14:00'
      expect(page).to have_field 'Data da abertura dos envelopes', :with => ''
      expect(page).to have_field 'Hora da abertura', :with => ''
      expect(page).to have_field 'Prazo de entrega', :with => '1'
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'ano/anos'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Valor da caução', :with => '50,00'
      expect(page).to have_select 'Parecer jurídico', :selected => 'Favorável'
      expect(page).to have_field 'Data do parecer', :with => '30/03/2012'
      expect(page).to have_field 'Data do contrato', :with => '31/03/2012'
      expect(page).to have_field 'Validade do contrato (meses)', :with => '5'
      expect(page).to have_field 'Observações gerais', :with => 'observacoes'

      # testing fields of licitation number
      expect(page).to have_field 'Número da licitação', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
    end

    within_tab 'Documentos' do
      expect(page).to have_content 'Fiscal'
      expect(page).to have_content '10'
    end

    within_tab 'Dotações' do
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_field 'Valor previsto', :with => '20,00'

      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Quantidade', :with => '2'
      expect(page).to have_field 'Valor unitário máximo', :with => '10,00'
      expect(page).to have_field 'Valor total', :with => '20,00'

      expect(page).to have_field 'Item', :with => '1'
    end

    within_tab 'Configuração da apuração' do
      expect(page).to have_checked_field 'Desclassificar participantes com problemas da documentação'
      expect(page).to have_checked_field 'Desclassificar participantes com cotações acima do valor máximo estabelecido no edital'
    end
  end

  scenario 'changing judgment form' do
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)
    JudgmentForm.make!(:por_lote_com_melhor_tecnica)
    JudgmentForm.make!(:por_item_com_menor_preco)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    expect(page).to have_title "Criar Processo Licitatório"

    expect(page).to_not have_link 'Publicações'

    within_tab 'Principal' do
      choose 'Processo licitatório'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'
      select 'Por Lote com Melhor Técnica', :from => 'Forma de julgamento'
      select 'Menor preço por lote', :from => 'Tipo da apuração'

      select 'Por Item com Menor Preço', :from => 'Forma de julgamento'
      select 'Menor preço total por item', :from => 'Tipo da apuração'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
    end
  end

  scenario 'update an existent licitation_process' do
    LicitationProcess.make!(:processo_licitatorio)
    Capability.make!(:construcao)
    PaymentMethod.make!(:cheque)
    DocumentType.make!(:oficial)
    Material.make!(:arame_farpado)
    Indexer.make!(:selic)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_title "Editar Processo Licitatório"
    expect(page).to have_subtitle "1/2012"

    expect(page).to have_link 'Publicações'

    within_tab 'Principal' do
      fill_in 'Data da expedição', :with => '21/03/2013'
      select 'Estimativo', :from => 'Tipo de empenho'
      select 'Menor preço total por item', :from => 'Tipo da apuração'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Fonte de recurso', :with => 'Construção', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '10'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'SELIC'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_in 'Hora da entrega', :with => '15:00'
      fill_in 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
      fill_in 'Hora da abertura', :with => '15:00'
      fill_in 'Prazo de entrega', :with => '3'
      select  'mês/meses', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Cheque', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '60,00'
      select 'Contrário', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2013'
      fill_in 'Data do contrato', :with => '31/03/2013'
      fill_in 'Validade do contrato (meses)', :with => '6'
      fill_in 'Observações gerais', :with => 'novas observacoes'
    end

    within_tab 'Documentos' do
      click_button 'Remover'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
    end

    within_tab 'Dotações' do
      click_button 'Remover Item'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor total', :with => '20,00'

      # asserting calculated unit price of the item
      expect(page).to have_field 'Valor unitário máximo', :with => '4,00'
    end

    within_tab 'Configuração da apuração' do
      uncheck 'Desclassificar participantes com problemas da documentação'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Data da expedição', :with => '21/03/2013'
      expect(page).to have_select 'Tipo de empenho', :selected => 'Estimativo'
      expect(page).to have_select 'Tipo da apuração', :selected => 'Menor preço total por item'
      expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
      expect(page).to have_select 'Tipo de garantia', :selected => 'Fiança bancária'
      expect(page).to have_field 'Fonte de recurso', :with => 'Construção'
      expect(page).to have_field 'Validade da proposta', :with => '10'
      expect(page).to have_select 'Período da validade da proposta', :selected => 'dia/dias'
      expect(page).to have_field 'Índice de reajuste', :with => 'SELIC'
      expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
      expect(page).to have_field 'Hora da entrega', :with => '15:00'
      expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
      expect(page).to have_field 'Hora da abertura', :with => '15:00'
      expect(page).to have_field 'Prazo de entrega', :with => '3'
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'mês/meses'
      expect(page).to have_field 'Forma de pagamento', :with => 'Cheque'
      expect(page).to have_field 'Valor da caução', :with => '60,00'
      expect(page).to have_select 'Parecer jurídico', :selected => 'Contrário'
      expect(page).to have_field 'Data do parecer', :with => '30/03/2013'
      expect(page).to have_field 'Data do contrato', :with => '31/03/2013'
      expect(page).to have_field 'Validade do contrato (meses)', :with => '6'
      expect(page).to have_field 'Observações gerais', :with => 'novas observacoes'
    end

    within_tab 'Documentos' do
      expect(page).to_not have_content 'Fiscal'

      expect(page).to have_content 'Oficial'
    end

    within_tab 'Dotações' do
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_field 'Valor previsto', :with => '20,00'

      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Quantidade', :with => '5'
      expect(page).to have_field 'Valor unitário máximo', :with => '4,00'
      expect(page).to have_field 'Valor total', :with => '20,00'

      expect(page).to have_field 'Item', :with => '1'
    end

    within_tab 'Configuração da apuração' do
      expect(page).to have_unchecked_field 'Desclassificar participantes com problemas da documentação'
      expect(page).to have_checked_field 'Desclassificar participantes com cotações acima do valor máximo estabelecido no edital'
    end
  end

  scenario 'calculating total of items via javascript' do
    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      click_button 'Adicionar Item'

      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor unitário máximo', :with => '10,00'

      expect(page).to have_field 'Valor total dos itens', :with => '50,00'

      click_button 'Adicionar Item'

      within '.item:first' do
        fill_in 'Quantidade', :with => '4'
        fill_in 'Valor unitário máximo', :with => '20,00'
      end

      expect(page).to have_field 'Valor total dos itens', :with => '130,00'

      within '.item:last' do
        click_button 'Remover Item'
      end

      expect(page).to have_field 'Valor total dos itens', :with => '80,00'
    end
  end

  scenario 'change document types to ensure that the changes are reflected on bidder documents' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    DocumentType.make!(:oficial)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    within_tab 'Documentos' do
      expect(page).to have_field 'Documento', :with => 'Fiscal'
    end

    click_link 'Voltar'

    click_link 'Voltar ao processo licitatório'

    within_tab 'Documentos' do
      click_button 'Remover'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 2/2013 editado com sucesso.'

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    within_tab 'Documentos' do
      expect(page).to_not have_field 'Documento', :with => 'Fiscal'
      expect(page).to have_field 'Documento', :with => 'Oficial'
    end
  end

  scenario "count link should not be available when envelope opening date is not the current date" do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_link 'Apurar'
  end

  scenario 'cannot show update and nested buttons when the publication is (extension, edital, edital_rectification)' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_publicacao_cancelada)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_disabled_element 'Salvar', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'

    click_link 'Documentos'
    expect(page).to have_disabled_element 'Remover', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'

    click_link 'Dotações orçamentárias'
    expect(page).to have_disabled_element 'Adicionar Item', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'
    expect(page).to have_disabled_element 'Remover Item', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'
  end

  scenario "should not have link to lots when creating a new licitation process" do
    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    expect(page).to_not have_link 'Lotes de itens'
  end

  scenario "should brings some filled fields when creating a new licitation process" do
    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      expect(page).to have_field 'Ano', :with => "#{Date.current.year}"
      expect(page).to have_field 'Data da expedição', :with => "#{I18n.l(Date.current)}"
    end
  end

  scenario 'budget allocation with quantity empty and total item value should have 0 as unit value' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações' do
      click_button 'Remover Item'
      click_button 'Adicionar Item'

      fill_in 'Valor total', :with => '20,00'

      expect(page).to have_field 'Valor unitário máximo', :with => '0,00'
    end
  end

  scenario 'create a new licitation_process with envelope opening date today' do
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      choose 'Processo licitatório'
      select 'Global', :from => 'Tipo de empenho'

      select 'Menor preço total por item', :from => 'Tipo da apuração'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => I18n.l(Date.current, :format => 'time')
      fill_in 'Data da abertura dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da abertura', :with => I18n.l(Date.current, :format => 'time')
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    click_button 'Salvar'

    expect(page).to_not have_content 'Routing Error No route matches'
  end

  scenario 'should filter by process' do
    LicitationProcess.make!(:processo_licitatorio)
    LicitationProcess.make!(:processo_licitatorio_computador, :process => 2)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      expect(page).to have_css 'a', :count => 2
    end

    click_link 'Filtrar Processos Licitatórios'

    fill_in 'Processo', :with => 1

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_css 'a', :count => 1
    end
  end

  scenario 'should not validate changes on bidders when classification is done' do
    licitation_process = LicitationProcess.make!(:apuracao_global,
                                                 :disqualify_by_documentation_problem => true)

    licitation_process.update_attributes({
      :envelope_opening_date => Date.tomorrow,
      :envelope_delivery_date => Date.tomorrow
    })

    price_registration = PriceRegistration.make!(:registro_de_precos,
                                                 :licitation_process => licitation_process)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    click_link '1/2012'

    click_button 'Apurar'

    expect(page).to have_content 'Ganhou'
  end

  scenario 'budget allocation items should have a sequential item' do
    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      click_button 'Adicionar Item'

      within '.item:last' do
        expect(page).to have_field 'Item', :with => '1'
      end

      click_button 'Adicionar Item'

      within '.item:first' do
        expect(page).to have_field 'Item', :with => '1'
      end

      within '.item:last' do
        expect(page).to have_field 'Item', :with => '2'
      end
    end
  end

  scenario 'allowance of adding bidders and publication of the edital' do
    LicitationProcess.make!(:processo_licitatorio,
                            :licitation_process_publications => [])

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link "1/2012"
    end

    expect(page).to have_disabled_element "Licitantes", :reason => "Licitantes só podem ser incluídos após publicação do edital"

    click_link "Publicações"

    click_link "Criar Publicação"

    fill_in "Nome do veículo de comunicação", :with => "website"

    fill_in "Data da publicação", :with => I18n.l(Date.current)

    select "Edital", :on => "Publicação do(a)"

    select "Internet", :on => "Tipo de circulação do veículo de comunicação"

    click_button "Salvar"

    expect(page).to have_notice "Publicação criada com sucesso"

    click_link "Voltar ao processo licitatório"

    click_link "Licitantes"

    expect(page).to have_content "Licitantes do Processo Licitatório 1/2012"
  end

  scenario "allowing changes to licitation process after ratification" do
    LicitationProcessRatification.make!(:processo_licitatorio_computador)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link "2/2013"
    end

    within_tab "Principal" do
      expect(page).to have_disabled_field "Forma de julgamento"
      expect(page).to have_disabled_field "Data da expedição"
      expect(page).to have_disabled_field "Fonte de recurso"
      expect(page).to have_disabled_field "Validade da proposta"
      expect(page).to have_disabled_field "Índice de reajuste"
      expect(page).to have_disabled_field "Observações gerais"
    end

    expect(page).to have_disabled_element 'Salvar',
                    :reason => 'já foi homologado. Não pode ser alterado'
  end

  scenario 'index with columns at the index' do
    LicitationProcess.make!(:processo_licitatorio, :status => LicitationProcessStatus::IN_PROGRESS)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      expect(page).to have_content 'Processo/Ano'
      expect(page).to have_content 'Modalidade'
      expect(page).to have_content 'Tipo de objeto'
      expect(page).to have_content 'Data da abertura dos envelopes'
      expect(page).to have_content 'Status'

      within 'tbody tr' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Compras e serviços'
        expect(page).to have_content I18n.l Date.tomorrow
        expect(page).to have_content 'Em andamento'
      end
    end
  end

  scenario 'generate calculation and disable a bidder by maximum value' do
    licitation_process = LicitationProcess.make!(:valor_maximo_ultrapassado, :disqualify_by_maximum_value => true)
    bidder = licitation_process.bidders.first
    LicitationProcessLot.make!(:lote, :licitation_process => licitation_process,
                               :administrative_process_budget_allocation_items => [licitation_process.items.first])

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço por lote'

    expect(page).to have_content 'Nohup'

    within ".classification-#{bidder.id}-0-0" do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to_not have_content 'IBM'
  end

  scenario 'generate calculation with equalized result' do
    licitation_process = LicitationProcess.make!(:apuracao_global_empatou)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '10,00'
      expect(page).to have_content '20,00'
      expect(page).to have_content 'Empatou'
    end

    expect(page).to have_content 'Wenderson Malheiros'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '10,00'
      expect(page).to have_content '20,00'
      expect(page).to have_content 'Empatou'
    end
  end

  scenario 'generate calculation with companies without documents and considering law of proposals' do
    licitation_process = LicitationProcess.make!(:apuracao_global_sem_documentos, :consider_law_of_proposals => true,
                                                 :disqualify_by_documentation_problem => true)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Nohup'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to_not have_content 'IBM'
  end

  scenario 'generate calculation with companies without documents' do
    licitation_process = LicitationProcess.make!(:apuracao_global_sem_documentos, :consider_law_of_proposals => false,
                                                 :disqualify_by_documentation_problem => true)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to_not have_content 'Nohup'

    expect(page).to_not have_content 'IBM'
  end

  scenario 'generate calculation between a small company and a big company without consider law of proposals' do
    licitation_process = LicitationProcess.make!(:apuracao_global_small_company, :consider_law_of_proposals => false)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Nohup'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Perdeu'
    end

    expect(page).to have_content 'IBM'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Ganhou'
    end
  end

  scenario 'generate calculation between a small company and a big company and consider law of proposals' do
    licitation_process = LicitationProcess.make!(:apuracao_global_small_company_2, :consider_law_of_proposals => true)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Nohup'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to have_content 'IBM'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Perdeu'
    end
  end

  scenario 'generate calculation between a small company and a big company and consider law of proposals and make a new proposal' do
    licitation_process = LicitationProcess.make!(:apuracao_global_small_company, :consider_law_of_proposals => true)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Nohup'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Empatou'
    end

    expect(page).to have_content 'IBM'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Empatou'
    end

    click_link 'voltar'

    click_link 'Licitantes'

    click_link 'Nohup'

    within_tab 'Propostas' do
      fill_in 'Preço unitário', :with => '8,99'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Licitante editado com sucesso.'

    click_link 'Voltar ao processo licitatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Nohup'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '8,99'
      expect(page).to have_content '17,98'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to have_content 'IBM'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Perdeu'
    end
  end

  scenario 'generate calculation between a small company and a big company and dont make a new proposal' do
    licitation_process = LicitationProcess.make!(:apuracao_global_small_company, :consider_law_of_proposals => true)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Nohup'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Empatou'
    end

    expect(page).to have_content 'IBM'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Empatou'
    end

    click_link 'voltar'

    click_link 'Licitantes'

    click_link 'Nohup'

    uncheck 'Apresentará nova proposta em caso de empate'

    click_button 'Salvar'

    expect(page).to have_notice 'Licitante editado com sucesso.'

    click_link 'Voltar ao processo licitatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Nohup'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to have_content 'IBM'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Perdeu'
    end
  end

  scenario 'generate calculation when type of calculation is global' do
    licitation_process = LicitationProcess.make!(:apuracao_global)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to have_content 'Wenderson Malheiros'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '10,00'
      expect(page).to have_content '20,00'
      expect(page).to have_content 'Perdeu'
    end

    click_link 'voltar'

    click_link 'Licitantes'

    click_link 'Wenderson Malheiros'

    within_tab 'Propostas' do
      expect(page).to have_select 'Situação', :selected => 'Perdeu'
      expect(page).to have_field 'Classificação', :with => '2'
    end

    click_link 'Voltar'

    click_link 'Gabriel Sobrinho'

    within_tab 'Propostas' do
      expect(page).to have_select 'Situação', :selected => 'Ganhou'
      expect(page).to have_field 'Classificação', :with => '1'
    end
  end

  scenario 'generate calculation when type of calculation is by lot' do
    licitation_process = LicitationProcess.make!(:apuracao_por_lote)
    LicitationProcessLot.make!(:lote, :licitation_process => licitation_process,
                               :administrative_process_budget_allocation_items => [licitation_process.items.first])
    LicitationProcessLot.make!(:lote_antivirus, :licitation_process => licitation_process,
                               :administrative_process_budget_allocation_items => [licitation_process.items.second])

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço por lote'

    expect(page).to have_content 'Wenderson Malheiros'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content '10,00'
        expect(page).to have_content '20,00'
        expect(page).to have_content 'Perdeu'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content '1'
        expect(page).to have_content '9,00'
        expect(page).to have_content 'Ganhou'
      end
    end

    expect(page).to have_content 'Gabriel Sobrinho'

    within 'table.records:nth-of-type(2)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content '9,00'
        expect(page).to have_content '18,00'
        expect(page).to have_content 'Ganhou'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content '1'
        expect(page).to have_content '10,00'
        expect(page).to have_content 'Perdeu'
      end
    end

    click_link 'voltar'

    click_link 'Licitantes'

    click_link 'Wenderson Malheiros'

    within_tab 'Propostas' do
      within_tab 'Lote 1' do
        expect(page).to have_select 'Situação', :selected => 'Perdeu'
        expect(page).to have_field 'Classificação', :with => '2'
      end

      within_tab 'Lote 2' do
        expect(page).to have_select 'Situação', :selected => 'Ganhou'
        expect(page).to have_field 'Classificação', :with => '1'
      end
    end

    click_link 'Voltar'

    click_link 'Gabriel Sobrinho'

    within_tab 'Propostas' do
      within_tab 'Lote 1' do
        expect(page).to have_select 'Situação', :selected => 'Ganhou'
        expect(page).to have_field 'Classificação', :with => '1'
      end

      within_tab 'Lote 2' do
        expect(page).to have_select 'Situação', :selected => 'Perdeu'
        expect(page).to have_field 'Classificação', :with => '2'
      end
    end
  end

  scenario 'generate calculation when type of calculation is by item' do
    licitation_process = LicitationProcess.make!(:apuracao_por_itens)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço total por item'

    expect(page).to have_content 'Wenderson Malheiros'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '10,00'
        expect(page).to have_content '20,00'
        expect(page).to have_content 'Perdeu'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '9,00'
        expect(page).to have_content 'Ganhou'
      end
    end

    expect(page).to have_content 'Gabriel Sobrinho'

    within 'table.records:nth-of-type(2)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '9,00'
        expect(page).to have_content '18,00'
        expect(page).to have_content 'Ganhou'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '10,00'
        expect(page).to have_content '10,00'
        expect(page).to have_content 'Perdeu'
      end
    end

    click_link 'voltar'

    click_link 'Relatório'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    click_link 'voltar'

    click_link 'Licitantes'

    click_link 'Wenderson Malheiros'

    within_tab 'Propostas' do
      expect(page).to have_select 'Situação', :selected => 'Perdeu'
      expect(page).to have_field 'Classificação', :with => '2'
    end

    click_link 'Voltar'

    click_link 'Gabriel Sobrinho'

    within_tab 'Propostas' do
      expect(page).to have_select 'Situação', :selected => 'Ganhou'
      expect(page).to have_field 'Classificação', :with => '1'
    end
  end

  scenario "button Back to Listings should take user to licitation_process#index" do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Voltar'

    click_link "Limpar Filtro"

    expect(page).to have_link '1/2012'

    expect(page).to have_title 'Processos Licitatórios'
  end

  scenario 'fill delivery_location automatically when has a purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo_liberado)
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)
    DeliveryLocation.make!(:health)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_field 'Local para entrega', :with => 'Secretaria da Educação'

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      choose 'Processo licitatório'
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => "Descrição"
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da expedição', :with => '21/03/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'
      select 'Por Item com Melhor Técnica', :from =>'Forma de julgamento'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Inciso', :with => 'Item 1'
      select 'Global', :from => 'Tipo de empenho'
      check 'Registro de preço'
      select 'Menor preço total por item', :from => 'Tipo da apuração'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => '14:00'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 criado com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'

      fill_modal 'Local de entrega', :with => 'Secretaria da Saúde', :field => "Descrição"
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Saúde'
    end

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_field 'Local para entrega', :with => 'Secretaria da Saúde'

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      clear_modal 'Local de entrega'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Local de entrega', :with => ''
    end

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_field 'Local para entrega', :with => 'Secretaria da Saúde'
  end

  scenario 'fill budget allocations from purchase solicitation item group' do
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:sobrinho)
    PurchaseSolicitationItemGroup.make!(:reparo_2013)
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      choose 'Processo licitatório'
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da expedição', :with => '21/03/2012'
      select 'Global', :from => 'Tipo de empenho'

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão', :from => 'Modalidade'
      select 'Por Item com Melhor Técnica', :from => 'Forma de julgamento'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Inciso', :with => 'Item 1'

      check 'Registro de preço'
      select 'Menor preço total por item', :from => 'Tipo da apuração'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => '14:00'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'

      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_readonly_field 'Compl. do elemento'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_readonly_field 'Saldo da dotação'

      expect(page).to have_field 'Valor previsto', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor previsto'

      expect(page).to have_field 'Valor total dos itens', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor total dos itens'

      expect(page).to_not have_button 'Adicionar Item'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_readonly_field 'Item'

      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Material'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_readonly_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '99,00'
      expect(page).to have_readonly_field 'Quantidade'

      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_readonly_field 'Valor unitário'

      expect(page).to have_field 'Valor total', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor total'

      expect(page).to_not have_button 'Remover Dotação'
      expect(page).to_not have_button 'Remover Item'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 criado com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da expedição', :with => '21/03/2012'
      expect(page).to have_select 'Tipo de empenho', :selected => 'Global'

      expect(page).to have_select 'Tipo de objeto', :selected => 'Compras e serviços'
      expect(page).to have_select 'Modalidade', :selected => 'Pregão'
      expect(page).to have_select 'Forma de julgamento', :selected => 'Por Item com Melhor Técnica'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Inciso', :with => 'Item 1'

      expect(page).to have_select 'Tipo da apuração', :selected => 'Menor preço total por item'
      expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
      expect(page).to have_select 'Tipo de garantia', :selected => 'Fiança bancária'
      expect(page).to have_field 'Fonte de recurso', :with => 'Reforma e Ampliação'
      expect(page).to have_field 'Validade da proposta', :with => '5'
      expect(page).to have_select 'Período da validade da proposta', :selected => 'dia/dias'
      expect(page).to have_field 'Índice de reajuste', :with => 'XPTO'
      expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      expect(page).to have_field 'Hora da entrega', :with => '14:00'
      expect(page).to have_field 'Prazo de entrega', :with => '1'
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'ano/anos'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Valor da caução', :with => '50,00'
      expect(page).to have_select 'Parecer jurídico', :selected => 'Favorável'
      expect(page).to have_field 'Data do parecer', :with => '30/03/2012'
      expect(page).to have_field 'Data do contrato', :with => '31/03/2012'
      expect(page).to have_field 'Validade do contrato (meses)', :with => '5'
      expect(page).to have_field 'Observações gerais', :with => 'observacoes'
      expect(page).to have_field 'Agrupamento de solicitações de compra', :with => 'Agrupamento de reparo 2013'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'

      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_readonly_field 'Compl. do elemento'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_readonly_field 'Saldo da dotação'

      expect(page).to have_field 'Valor previsto', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor previsto'

      expect(page).to have_field 'Valor total dos itens', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor total dos itens'

      expect(page).to_not have_button 'Adicionar Item'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_readonly_field 'Item'

      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Material'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_readonly_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '99'
      expect(page).to have_readonly_field 'Quantidade'

      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_readonly_field 'Valor unitário'

      expect(page).to have_field 'Valor total', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor total'

      expect(page).to_not have_button 'Remover Dotação'
      expect(page).to_not have_button 'Remover Item'
    end

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      click_link 'Agrupamento de reparo 2013'
    end

    expect(page).to have_select 'Situação', :selected => 'Em processo de compra'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      click_link '1/2013'
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Parcialmente atendido'
    end
  end

  scenario 'when clear purchase solicitation item group budget allocations should clear too' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      expect(page).to_not have_disabled_field 'Solicitação de compra'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end

      expect(page).to have_disabled_field 'Solicitação de compra'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'

      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_readonly_field 'Compl. do elemento'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_readonly_field 'Saldo da dotação'

      expect(page).to have_field 'Valor previsto', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor previsto'

      expect(page).to have_field 'Valor total dos itens', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor total dos itens'

      expect(page).to_not have_button 'Adicionar Item'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_readonly_field 'Item'

      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Material'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_readonly_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '99,00'
      expect(page).to have_readonly_field 'Quantidade'

      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_readonly_field 'Valor unitário'

      expect(page).to have_field 'Valor total', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor total'

      expect(page).to_not have_button 'Remover Dotação'
      expect(page).to_not have_button 'Remover Item'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    within_tab 'Principal' do
      clear_modal 'Agrupamento de solicitações de compra'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_button 'Adicionar Dotação'

      expect(page).to_not have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to_not have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to_not have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to_not have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to_not have_field 'Valor previsto', :with => '19.800,00'
      expect(page).to_not have_field 'Valor total dos itens', :with => '19.800,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'
    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Situação', :selected => 'Pendente'
  end

  scenario 'should show only purchase_solicitation_item_group not annulled' do
    PurchaseSolicitationItemGroup.make!(:antivirus)

    ResourceAnnul.make!(:anulacao_generica,
                        :annullable => PurchaseSolicitationItemGroup.make!(:reparo_2013))

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        within_records do
          expect(page).to_not have_content 'Agrupamento de reparo 2013'
          expect(page).to have_content 'Agrupamento de antivirus'
        end
      end
    end
  end

  scenario 'when select disposals_of_assets as object_type should show only best_auction_or_offer' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      select 'Alienação de bens', :from => 'Tipo de objeto'
      select 'Leilão', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Global com Melhor Lance ou Oferta'])
    end
  end

  scenario 'when select concessions_and_permits as object_type should show only best_auction_or_offer' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      select 'Concessões e permissões', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Global com Melhor Lance ou Oferta'])
    end
  end

  scenario 'when select call_notice as object_type should show only best_technique' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      select 'Edital de chamamento/credenciamento', :from => 'Tipo de objeto'
      select 'Concurso', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica'])
    end
  end

  scenario 'when select construction_and_engineering_services as object_type should show only lowest_price and best_technique' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      select 'Obras e serviços de engenharia', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])

      select 'Tomada de Preço', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])

      select 'Convite', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])

      select 'Concurso', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])

      select 'Pregão', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])
    end
  end

  scenario 'when select purchase_and_services as object_type should show only lowest_price and best_technique' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])

      select 'Tomada de Preço', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])

      select 'Convite', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])

      select 'Pregão', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])
    end
  end

  scenario 'when clear object_type should not filter licitation_kind in judgment_form modal' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      select 'Compras e serviços', :from => 'Tipo de objeto'

      select '', :from => 'Tipo de objeto'

      expect(page).to have_select('Modalidade', :options => [])

      expect(page).to have_select('Forma de julgamento', :options => [])
    end
  end

  scenario 'when clear item group purchase solicitation item should clear budget_allocations' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'

      within '.nested-administrative-process-budget-allocation:first' do
        fill_in 'Valor previsto', :with => '10,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    within_tab 'Principal' do
      clear_modal 'Agrupamento de solicitações de compra'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to_not have_field 'Saldo da dotação', :with => '500,00'
    end
  end

  scenario 'when clear item group purchase solicitation item should clear fulfiller' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      click_link '1/2013'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        within '.item:first' do
          expect(page).to have_field 'Atendido por', :with => 'Processo licitatório 1/2012'
        end
      end
    end

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      clear_modal 'Agrupamento de solicitações de compra'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      click_link '1/2013'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        within '.item:first' do
          expect(page).to have_field 'Atendido por', :with => ''
        end
      end
    end
  end

  scenario 'assigns a fulfiller to the purchase solicitation budget allocation item when assign a purchase_solicitation_item_group to licitation_process' do
    PurchaseSolicitationItemGroup.make!(:antivirus)
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    expect(page).to have_content "Criar Processo"

    expect(page).to_not have_link 'Publicações'

    expect(page).to_not have_button 'Apurar'

    expect(page).to have_disabled_field 'Status'

    within_tab 'Principal' do
      choose 'Processo licitatório'
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da expedição', :with => '21/03/2012'
      select 'Global', :from => 'Tipo de empenho'

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'
      select 'Por Item com Melhor Técnica', :from =>'Forma de julgamento'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Inciso', :with => 'Item 1'

      check 'Registro de preço'
      select 'Menor preço total por item', :from => 'Tipo da apuração'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => '14:00'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 criado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Atendido por', :with => 'Processo licitatório 1/2012'
    end
  end

  scenario "filtering modalities based on seleted object type" do
    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    select 'Compras e serviços', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concorrência', 'Tomada de Preço', 'Convite', 'Pregão'])

    select 'Alienação de bens', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Leilão'])

    select 'Concessões e permissões', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concorrência'])

    select 'Edital de chamamento/credenciamento', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concurso'])

    select 'Obras e serviços de engenharia', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concorrência', 'Tomada de Preço', 'Convite', 'Concurso', 'Pregão'])
  end

  scenario "changing the purchase_solicitation_item_group should change purchase solicitation items fulfiller" do
    PurchaseSolicitationItemGroup.make!(:antivirus)
    PurchaseSolicitationItemGroup.make!(:office)
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Atendido por', :with => 'Processo licitatório 1/2012'
    end

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de office'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Atendido por', :with => ''
    end

    click_link 'Voltar'

    click_link "Limpar Filtro"

    within_records do
      click_link '2/2012'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Atendido por', :with => 'Processo licitatório 1/2012'
    end
  end

  scenario "changing the purchase_solicitation_item_group should change purchase solicitation and items status" do
    item_group = PurchaseSolicitationItemGroup.make!(:antivirus)
    item_group.purchase_solicitation_items.each do |item|
      item.update_column :purchase_solicitation_item_group_id, item_group.id
    end
    item_group = PurchaseSolicitationItemGroup.make!(:office)
    item_group.purchase_solicitation_items.each do |item|
      item.update_column :purchase_solicitation_item_group_id, item_group.id
    end
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Parcialmente atendido'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation' do
        within '.item' do
          expect(page).to have_select 'Status', :selected => 'Parcialmente atendido'
          expect(page).to have_field 'Agrupamento', :with => 'Agrupamento de antivirus'
          expect(page).to have_field 'Atendido por', :with => 'Processo licitatório 1/2012'
        end
      end
    end

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de office'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      #expect(page).to have_select 'Status de atendimento', :selected => 'Liberada'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        within '.item' do
          expect(page).to have_select 'Status', :selected => 'Pendente'
          expect(page).to have_field 'Agrupamento', :with => ''
          expect(page).to have_field 'Atendido por', :with => ''
        end
      end
    end

    click_link 'Voltar'

    click_link "Limpar Filtro"

    within_records do
      click_link '2/2012'
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Parcialmente atendido'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation' do
        within '.item' do
          expect(page).to have_select 'Status', :selected => 'Parcialmente atendido'
          #expect(page).to have_field 'Agrupamento', :with => 'Agrupamento de antivirus'
          expect(page).to have_field 'Atendido por', :with => 'Processo licitatório 1/2012'
        end
      end
    end
  end

  scenario 'clear budget allocations when purchase_solicititation is removed' do
    PurchaseSolicitation.make!(:reparo_liberado)
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:sobrinho)
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    expect(page).to be_on_tab 'Principal'

    within_tab 'Principal' do
      choose 'Processo licitatório'
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da expedição', :with => '07/03/2012'
      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Global', :from => 'Tipo de empenho'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_disabled_field 'Agrupamento de solicitações de compra'

      select 'Pregão', :from => 'Modalidade'
      select 'Alienação de bens', :from => 'Tipo de objeto'

      expect(page).to have_select 'Modalidade', :selected => ''

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão', :from => 'Modalidade'

      select 'Por Item com Melhor Técnica', :from =>'Forma de julgamento'
      fill_in 'Objeto resumido do processo licitatório', :with => 'Objeto resumido'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Inciso', :with => 'Item 1'
      select 'Menor preço total por item', :from => 'Tipo da apuração'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => '14:00'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_disabled_field 'Saldo da dotação'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 criado com sucesso.'

    within_tab 'Principal' do
      clear_modal 'Solicitação de compra'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_button 'Adicionar Dotação'
      expect(page).to_not have_field 'Dotação orçamentária', :with => '1 - Alocação'

      expect(page).to_not have_field 'Saldo da dotação', :with => '500,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Liberada'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation' do
        within '.item' do
          expect(page).to have_select 'Status', :selected => 'Pendente'
          #expect(page).to have_field 'Agrupamento', :with => 'Agrupamento de antivirus'
          expect(page).to have_field 'Atendido por', :with => ''
        end
      end
    end
  end

  scenario 'budget allocations should be fulfilled automatically when fulfill purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo_liberado)
    Employee.make!(:sobrinho)
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    expect(page).to have_content "Criar Processo"

    expect(page).to_not have_link 'Publicações'

    expect(page).to_not have_button 'Apurar'

    expect(page).to have_disabled_field 'Status'

    within_tab 'Principal' do
      choose 'Processo licitatório'
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da expedição', :with => '21/03/2012'
      select 'Global', :from => 'Tipo de empenho'

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'
      select 'Por Item com Melhor Técnica', :from =>'Forma de julgamento'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Inciso', :with => 'Item 1'

      check 'Registro de preço'
      select 'Menor preço total por item', :from => 'Tipo da apuração'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => '14:00'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_readonly_field 'Compl. do elemento'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_readonly_field 'Saldo da dotação'

      expect(page).to have_field 'Valor previsto', :with => '600,00'

      expect(page).to have_field 'Valor total dos itens', :with => '600,00'
      expect(page).to have_readonly_field 'Valor total dos itens'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_readonly_field 'Item'

      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_readonly_field 'Material'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_readonly_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '3,00'
      expect(page).to have_readonly_field 'Quantidade'

      expect(page).to have_field 'Valor unitário máximo', :with => '200,00'
      expect(page).to have_readonly_field 'Valor unitário máximo'

      expect(page).to have_field 'Valor total', :with => '600,00'
      expect(page).to have_readonly_field 'Valor total'

      expect(page).to_not have_button 'Adicionar Item'
      expect(page).to_not have_button 'Remover Item'
      expect(page).to_not have_button 'Remover Dotação'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório 1/2012 criado com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Solicitação de compra', :with => '1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_disabled_field 'Compl. do elemento'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_disabled_field 'Saldo da dotação'

      expect(page).to have_field 'Valor previsto', :with => '600,00'
      expect(page).to have_disabled_field 'Valor previsto'

      expect(page).to have_field 'Valor total dos itens', :with => '600,00'
      expect(page).to have_disabled_field 'Valor total dos itens'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_disabled_field 'Item'

      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Material'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_disabled_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '3'
      expect(page).to have_disabled_field 'Quantidade'

      expect(page).to have_field 'Valor unitário máximo', :with => '200,00'
      expect(page).to have_disabled_field 'Valor unitário máximo'

      expect(page).to have_field 'Valor total', :with => '600,00'
      expect(page).to have_disabled_field 'Valor total'

      expect(page).to_not have_button 'Adicionar Item'
      expect(page).to_not have_button 'Remover Item'
      expect(page).to_not have_button 'Remover Dotação'
    end

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações orçamentárias' do
      within '.item:nth-child(1)' do
        expect(page).to have_select 'Status', :selected => 'Parcialmente atendido'
        expect(page).to have_field 'Atendido por', :with => 'Processo licitatório 1/2012'
      end
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Parcialmente atendido'
    end
  end

  scenario 'when clear purchase_solicitation should enable item_group' do
    PurchaseSolicitation.make!(:reparo_liberado)
    PurchaseSolicitationItemGroup.make!(:antivirus)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    expect(page).to be_on_tab 'Principal'

    within_tab 'Principal' do
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_disabled_field 'Agrupamento de solicitações de compra'

      clear_modal 'Solicitação de compra'

      expect(page).to_not have_disabled_field 'Agrupamento de solicitações de compra'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end

      expect(page).to have_disabled_field 'Solicitação de compra'
    end
  end

  scenario 'cannot overwrite reponsible when select a purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo_liberado)
    PurchaseSolicitationItemGroup.make!(:antivirus)
    Employee.make!(:wenderson)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Principal' do
      fill_modal 'Responsável', :field => 'Matrícula', :with => '12903412'
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_field 'Responsável', :with => 'Wenderson Malheiros'

      clear_modal 'Responsável'
      clear_modal 'Solicitação de compra'

      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    end
  end

  scenario 'should not return duplicated data of purchase solicitation' do
     purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado,
                                                        :purchase_solicitation_budget_allocations => [
                                                          PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_office_2_itens_liberados)])

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      expect(page).to have_css 'table.records tbody tr', :count => 1
    end
  end

  scenario 'should show only item group pending' do
    PurchaseSolicitationItemGroup.make!(:antivirus)
    PurchaseSolicitationItemGroup.make!(:reparo_2013,
      :status => PurchaseSolicitationItemGroupStatus::FULFILLED)
    PurchaseSolicitationItemGroup.make!(:antivirus_desenvolvimento,
      :status => PurchaseSolicitationItemGroupStatus::ANNULLED)

    navigate 'Processo Administrativo/Licitatório > Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_modal 'Agrupamento de solicitações de compra' do
      click_button 'Pesquisar'

      expect(page).to have_css 'table.records tbody tr', :count => 1
    end
  end
end
