#: encoding: utf-8
require 'spec_helper'

feature "BankAccounts" do
  background do
    sign_in
  end

  scenario 'create a new bank_account' do
    Agency.make!(:itau)

    navigate 'Contabilidade > Comum > Contas Bancárias'

    click_link 'Criar Conta Bancária'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Status'
      expect(page).to have_select 'Status', :selected => 'Ativo'
      select 'Aplicação', :from => 'Tipo'
      fill_in 'Descrição', :with => 'IPTU'
      fill_modal 'Banco', :with => 'Itaú'

      within_modal 'Agência' do
        expect(page).to have_field 'Banco', :with => 'Itaú'

        fill_in 'Nome', :with => 'Agência Itaú'
        click_button 'Pesquisar'

        click_record 'Agência Itaú'
      end
      expect(page).to have_field 'Número da agência', :with => '10009'
      expect(page).to have_field 'Dígito da agência', :with => '1'

      fill_in 'Número da conta corrente', :with => '1111113'
      fill_in 'Dígito da conta corrente', :with => '1'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Conta Bancária criado com sucesso.'

    click_link 'IPTU'

    within_tab 'Principal' do
      expect(page).to have_select 'Status', :selected => 'Ativo'
      expect(page).to have_select 'Tipo', :selected => 'Aplicação'
      expect(page).to have_field 'Descrição', :with => 'IPTU'
      expect(page).to have_field 'Agência', :with => 'Agência Itaú'
      expect(page).to have_field 'Número da agência', :with => '10009'
      expect(page).to have_field 'Dígito da agência', :with => '1'
      expect(page).to have_field 'Número da conta corrente', :with => '1111113'
      expect(page).to have_field 'Dígito da conta corrente', :with => '1'
    end
  end

  scenario 'update an existent bank_account' do
    BankAccount.make!(:itau_tributos)

    navigate 'Contabilidade > Comum > Contas Bancárias'

    click_link 'Itaú Tributos'

    within_tab 'Principal' do
      fill_in 'Descrição', :with => 'IPTU'

      select 'Inativo', :from => 'Status'
      select 'Movimento', :from => 'Tipo'
      fill_in 'Número da conta corrente', :with => '1111114'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Conta Bancária editado com sucesso.'

    click_link 'IPTU'

    within_tab 'Principal' do
      expect(page).to have_select 'Status', :selected => 'Inativo'
      expect(page).to have_select 'Tipo', :selected => 'Movimento'
      expect(page).to have_field 'Descrição', :with => 'IPTU'
      expect(page).to have_field 'Número da conta corrente', :with => '1111114'
    end
  end

  scenario 'when fill/clear agency should fill/clear related fields' do
    Agency.make!(:itau)

    navigate 'Contabilidade > Comum > Contas Bancárias'

    click_link 'Criar Conta Bancária'

    within_tab 'Principal' do
      fill_modal 'Agência', :with => 'Agência Itaú'

      expect(page).to have_field 'Número da agência', :with => '10009'
      expect(page).to have_field 'Dígito da agência', :with => '1'
    end

    clear_modal 'Agência'

    within_tab 'Principal' do
      expect(page).to have_field 'Número da agência', :with => ''
      expect(page).to have_field 'Dígito da agência', :with => ''
    end
  end

  scenario 'when clear bank should clear agency too' do
    Agency.make!(:itau)

    navigate 'Contabilidade > Comum > Contas Bancárias'

    click_link 'Criar Conta Bancária'

    within_tab 'Principal' do
      fill_modal 'Banco', :with => 'Itaú'
      fill_modal 'Agência', :with => 'Agência Itaú'

      clear_modal 'Banco'

      expect(page).to_not have_field 'Agência', :with => 'Agência Itaú'
      within_modal 'Agência' do
        expect(page).to_not have_field 'Banco', :with => 'Itaú'
      end
    end
  end

  scenario 'when select agency before bank, bank should fill bank' do
    Agency.make!(:itau)

    navigate 'Contabilidade > Comum > Contas Bancárias'

    click_link 'Criar Conta Bancária'

    within_tab 'Principal' do
      fill_modal 'Agência', :with => 'Agência Itaú'

      expect(page).to have_field 'Banco', :with => 'Itaú'
    end
  end

  scenario 'when fill bank and submit form with errors should return with bank' do
    Agency.make!(:itau)

    navigate 'Contabilidade > Comum > Contas Bancárias'

    click_link 'Criar Conta Bancária'

    within_tab 'Principal' do
      fill_modal 'Banco', :with => 'Itaú'
    end

    click_button 'Salvar'

    within_tab 'Principal' do
      expect(page).to have_field 'Banco', :with => 'Itaú'
    end
  end

  scenario 'destroy an existent bank_account' do
    BankAccount.make!(:itau_tributos)

    navigate 'Contabilidade > Comum > Contas Bancárias'

    click_link 'Itaú Tributos'

    click_link 'Apagar'

    expect(page).to have_notice 'Conta Bancária apagado com sucesso.'

    expect(page).not_to have_content 'Itaú Tributos'
  end
end
