# encoding: utf-8
require 'spec_helper'

feature "SpecialEntries" do
  background do
    sign_in
  end

  scenario 'create a new special_entry' do
    navigate 'Comum > Pessoas > Inscrições Especiais'

    click_link 'Criar Inscrição Especial'

    fill_in 'Nome', :with => 'Tal'

    click_button 'Salvar'

    expect(page).to have_notice 'Inscrição Especial criada com sucesso.'

    click_link 'Tal'

    expect(page).to have_field 'Nome', :with => 'Tal'
  end

  scenario 'update an existent special_entry' do
    SpecialEntry.make!(:example)

    navigate 'Comum > Pessoas > Inscrições Especiais'

    click_link 'Tal'

    fill_in 'Nome', :with => 'Fulano'

    click_button 'Salvar'

    expect(page).to have_notice 'Inscrição Especial editada com sucesso.'

    click_link 'Fulano'

    expect(page).to have_field 'Nome', :with => 'Fulano'
  end

  scenario 'destroy an existent special_entry' do
    SpecialEntry.make!(:example)

    navigate 'Comum > Pessoas > Inscrições Especiais'

    click_link 'Tal'

    click_link 'Apagar'

    expect(page).to have_notice 'Inscrição Especial apagada com sucesso.'

    expect(page).to_not have_content 'Tal'
  end

  scenario 'index with columns at the index' do
    SpecialEntry.make!(:example)

    navigate 'Comum > Pessoas > Inscrições Especiais'

    within_records do
      expect(page).to have_content 'Nome'

      within 'tbody tr' do
        expect(page).to have_content 'Tal'
      end
    end
  end
end
