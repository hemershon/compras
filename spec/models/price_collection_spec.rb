# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection'
require 'app/models/price_collection_lot'
require 'app/models/price_collections_provider'
require 'app/models/price_collection_proposal'

describe PriceCollection do
  context '#relationships' do
    it { should belong_to :delivery_location }
    it { should belong_to :employee }
    it { should belong_to :payment_method }
    it { should have_many :price_collection_lots }
    it { should have_many(:price_collections_providers).dependent(:destroy).order(:id) }
    it { should have_many(:price_collection_proposals).dependent(:destroy).order(:id) }
    it { should have_many(:providers).through(:price_collections_providers) }
    it { should have_many(:items).through(:price_collection_lots) }
  end

  context '#validations' do
    it { should validate_presence_of :collection_number }
    it { should validate_presence_of :year }
    it { should validate_presence_of :date }
    it { should validate_presence_of :delivery_location }
    it { should validate_presence_of :employee }
    it { should validate_presence_of :payment_method }
    it { should validate_presence_of :period }
    it { should validate_presence_of :period_unit }
    it { should validate_presence_of :object_description }
    it { should validate_presence_of :expiration }
    it { should validate_presence_of :proposal_validity }
    it { should validate_presence_of :proposal_validity_unit }

    it { should allow_value('2012').for(:year) }
    it { should_not allow_value('201').for(:year) }
    it { should_not allow_value('a201').for(:year) }

    it 'should not have date less than today' do
      subject.should_not allow_value(Date.yesterday).for(:date).
                                                     with_message("deve ser em ou depois de #{I18n.l Date.current}")
    end

    it 'should not have expiration less than today' do
      subject.should_not allow_value(Date.yesterday).for(:expiration).
                                                     with_message("deve ser em ou depois de #{I18n.l Date.current}")
    end
  end

  it "should return number/year as to_s method" do
    subject.collection_number = 5
    subject.year = 2012

    subject.to_s.should eq '5/2012'
  end

  describe '#next_collection_number' do
    context 'when do not has a price collection with the same year' do
      before do
        subject.stub(:last_by_self_year).and_return(nil)
      end

      it 'should be 1' do
        subject.next_collection_number.should eq 1
      end
    end

    context 'when the collection_number of last price collection is 4' do
      before do
        subject.stub(:last_by_self_year).and_return(last_by_self_year)
      end

      let :last_by_self_year do
        double(:last_by_self_year, :collection_number => 4)
      end

      it 'should be 5' do
        subject.next_collection_number.should eq 5
      end
    end
  end
end
