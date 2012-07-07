# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_solicitation_decorator'

describe PurchaseSolicitationDecorator do
  it 'should return budget_structure, responsible and status on summary' do
    subject.stub(:budget_structure).and_return('Secretaria de educação')
    subject.stub(:responsible).and_return('Nohup')
    subject.stub(:service_status_humanize).and_return('Pendente')

    subject.summary.should eq "Estrutura orçamentaria solicitante: Secretaria de educação / Responsável pela solicitação: Nohup / Status: Pendente"
  end

  it "should return a link to new purchase solicitation liberation" do
    component.stub(:persisted?).and_return(true)
    component.stub(:pending?).and_return(true)
    component.stub(:id).and_return(1)
    routes.stub(:new_purchase_solicitation_liberation_path).with({:purchase_solicitation_id => 1}).and_return('new_path')
    helpers.stub(:link_to).with('Liberar', 'new_path', { :class => 'button primary' }).and_return('new_link')

    subject.link_to_liberation.should eq 'new_link'
  end

  context "with purchase_solicitation_liberation" do
    let :purchase_solicitation_liberation do
      double(:purchase_solicitation_liberation, :id => 1)
    end

    it "should return a link to edit purchase_solicitation_liberation" do
      component.stub(:persisted?).and_return(true)
      component.stub(:pending?).and_return(false)
      component.stub(:liberated?).and_return(true)
      component.stub(:id).and_return(1)
      component.stub(:liberation).and_return(purchase_solicitation_liberation)
      routes.stub(:edit_purchase_solicitation_liberation_path).with({:purchase_solicitation_id => 1, :id => 1}).and_return('edit_path')
      helpers.stub(:link_to).with('Liberar', 'edit_path', { :class => 'button primary' }).and_return('edit_link')

      subject.link_to_liberation.should eq 'edit_link'
    end
  end
end
