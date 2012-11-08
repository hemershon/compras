require 'model_helper'
require 'app/models/administrative_process_budget_allocation_item'
require 'app/models/trading'
require 'app/models/trading_item'
require 'app/models/trading_item_bid'

describe TradingItem do
  it { should belong_to :trading }
  it { should belong_to :administrative_process_budget_allocation_item }

  it { should have_many(:trading_item_bids).dependent(:destroy) }
  it { should have_many(:bidders).through(:trading).order(:id) }

  it { should delegate(:material).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:material_id).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:reference_unit).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:quantity).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:unit_price).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:licitation_process_id).to(:trading) }

  it "has a default value of 0 to minimum_reduction_percent" do
    expect(TradingItem.new.minimum_reduction_percent).to eq 0.0
  end

  it "has a default value of 0 to minimum_reduction_value" do
    expect(TradingItem.new.minimum_reduction_value).to eq 0.0
  end

  context "delegates" do
    let(:administrative_process_item) { double(:process_item) }

    before do
      subject.stub(:administrative_process_budget_allocation_item => administrative_process_item)
    end

    describe "#to_s" do
      it "delegates to administrative_process_budget_allocation_item" do
        administrative_process_item.should_receive(:to_s)
        subject.to_s
      end
    end
  end

  context "validations" do
    subject do
      TradingItem.new(:minimum_reduction_value => 1.0,
                      :minimum_reduction_percent => 1.0)
    end

    it "validates if minimum percent is zero if minimum_value is present" do
      subject.valid?

      expect(subject.errors[:minimum_reduction_value]).to include "deve ser igual a 0.0"
    end

    it "validates if minimum value is zero if minimum_percent is present" do
      subject.valid?

      expect(subject.errors[:minimum_reduction_percent]).to include "deve ser igual a 0.0"
    end

    it "validates if reduction percent is less than or equal to 100" do
      subject.minimum_reduction_percent = 101.0
      subject.valid?

      expect(subject.errors[:minimum_reduction_percent]).to include "deve ser menor ou igual a 100"
    end
  end

  describe '#last_proposal' do
    it 'should return the last bid proposal value for the item' do
      first_bid = double(:first_bid, :amount => 50.0)
      second_bid = double(:second_bid, :amount => 40.0)
      third_bid = double(:third_bid, :amount => 30.0)
      trading_item_bids = double(:trading_item_bids)

      trading_item_bids.should_receive(:with_proposal).and_return([first_bid, second_bid, third_bid])

      subject.should_receive(:trading_item_bids).and_return(trading_item_bids)

      expect(subject.last_proposal_value).to eq 30.0
    end

    it 'should return zero when there is no proposal for the item' do
      trading_item_bids = double(:trading_item_bids)

      trading_item_bids.should_receive(:with_proposal).and_return([])

      subject.should_receive(:trading_item_bids).and_return(trading_item_bids)

      expect(subject.last_proposal_value).to eq 0
    end
  end

  describe '#last_bid_round' do
    it 'should return the last bid round' do
      first_bid = double(:first_bid, :id => 1, :round => 1)
      second_bid = double(:second_bid, :id => 2, :round => 1)

      subject.should_receive(:trading_item_bids).and_return([first_bid, second_bid])

      expect(subject.last_bid_round).to eq 1
    end

    it 'should return zero when there are no rounds' do
      subject.should_receive(:trading_item_bids).and_return([])

      expect(subject.last_bid_round).to eq 0
    end
  end
end
