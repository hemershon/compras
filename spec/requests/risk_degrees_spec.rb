# encoding: utf-8
require 'spec_helper'

feature "RiskDegrees" do
  background do
    sign_in
  end

  scenario 'create a new risk_degree' do
    navigate_through 'Outros > Grau de Riscos'

    click_link 'Criar Grau de Risco'

    fill_in 'Nível', :with => '1'
    fill_in 'Nome', :with => 'Médio'

    click_button 'Salvar'

    page.should have_notice 'Grau de Risco criado com sucesso.'

    click_link 'Médio'

    page.should have_field 'Nível', :with => "1"
    page.should have_field 'Nome', :with => "Médio"
  end

  scenario 'update an existent risk_degree' do
    risk_degree = RiskDegree.make!(:leve)

    navigate_through 'Outros > Grau de Riscos'

    click_link 'Leve'

    fill_in 'Nome', :with => 'Muito Grave'
    fill_in 'Nível', :with => '4'

    click_button 'Salvar'

    page.should have_notice 'Grau de Risco editado com sucesso.'

    click_link 'Muito Grave'

    page.should have_field 'Nível', :with => "4"
    page.should have_field 'Nome', :with => "Muito Grave"
  end

  scenario 'destroy an existent risk_degree' do
    risk_degree = RiskDegree.make!(:grave)

    navigate_through 'Outros > Grau de Riscos'

    click_link 'Grave'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Grau de Risco apagado com sucesso.'

    page.should_not have_content 'Grave'
  end
end
