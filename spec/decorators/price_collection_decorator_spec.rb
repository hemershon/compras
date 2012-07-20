# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_collection_decorator'

describe PriceCollectionDecorator do
  context '#winner_proposal_total_price' do
    before do
      component.stub(:winner_proposal_total_price).and_return(9.99)
    end

    it 'should applies precision' do
      subject.winner_proposal_total_price.should eq '9,99'
    end
  end

  context '#proposals_link' do
    before do
      routes.stub(:price_collection_price_collection_proposals_path).with(component).and_return '#'
    end

    it 'should return the link for proposal when the price collection is persisted' do
      component.stub(:persisted?).and_return true

      subject.proposals_link.should eq '<a href="#" class="button primary">Propostas</a>'
    end

    it 'should not return the link for proposal when the price collection is not persisted' do
      component.stub(:persisted?).and_return false

      subject.proposals_link.should eq nil
    end
  end
end
