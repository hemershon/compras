# encoding: utf-8
require 'unit_helper'
require 'app/business/purchase_solicitation_item_group_annulment'

describe PurchaseSolicitationItemGroupAnnulment do
  subject do
    PurchaseSolicitationItemGroupAnnulment.new(
      item_group,
      item_status_changer,
      resource_annul_repository
    )
  end

  let :item_group do
    double(:item_group, :id => 2)
  end

  let :resource_annul_repository do
    double(:resource_annul_repository)
  end

  let :item_status_changer do
    double(:item_status_changer, :change => true)
  end

  context '#annul' do
    it 'should change the status of purchase_solicitation_items to pending' do
      item_group.stub(:purchase_solicitation_item_ids).and_return([1, 2, 3])

      item_status_changer.should_receive(:new).
                          with(:old_item_ids => [1, 2, 3]).
                          and_return(item_status_changer)

      subject.annul
    end
  end

  context '#create_annulment' do
    let :employee do
      double(:employee, :id => 1)
    end

    it 'should create an resouce_annul and annul it' do
      item_group.stub(:class).and_return(double(:class, :name => 'PurchaseSolicitationItemGroup'))

      resource_annul_repository.should_receive(:create!).
                                with(
                                    :employee_id => 1,
                                    :date => Date.new(2012, 10, 01),
                                    :description => 'Anulação',
                                    :annullable_id => 2,
                                    :annullable_type => 'PurchaseSolicitationItemGroup'
                                  )

      subject.should_receive(:annul)

      subject.create_annulment(employee, Date.new(2012, 10, 01), 'Anulação')
    end
  end
end