require 'spec_helper'

describe TradingItem do
  describe 'validations' do
    subject do
      TradingItem.make!(:item_pregao_presencial)
    end

    context 'with both minimum_reductions' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 1.0,
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

    context 'with no minimum_reduction_percent nor minimum_reduction_value' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 0.0,
          :minimum_reduction_percent => 0.0)
      end

      it 'validates at least one minimum_reduction' do
        subject.valid?

        expect(subject.errors[:minimum_reduction_percent]).to include "um dos campos precisa ser preenchido"
        expect(subject.errors[:minimum_reduction_value]).to include "um dos campos precisa ser preenchido"
      end
    end

    context 'with minimum_reduction_percent' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 0.0,
          :minimum_reduction_percent => 10.0)
      end

      it 'does not validate at least one minimum_reduction when have minimum_reduction_percent' do
        subject.valid?

        expect(subject.errors[:minimum_reduction_value]).to_not include "um dos campos precisa ser preenchido"
        expect(subject.errors[:minimum_reduction_percent]).to_not include "um dos campos precisa ser preenchido"
      end
    end

    context 'with minimum_reduction_percent' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 10.0,
          :minimum_reduction_percent => 0.0)
      end

      it 'does not validate at least one minimum_reduction when have minimum_reduction_value' do
        subject.valid?

        expect(subject.errors[:minimum_reduction_percent]).to_not include "um dos campos precisa ser preenchido"
        expect(subject.errors[:minimum_reduction_value]).to_not include "um dos campos precisa ser preenchido"
      end
    end
  end

  describe '.not_closed' do
    let :closed_item do
      TradingItem.make!(:item_pregao_presencial)
    end

    let :not_closed_item do
      TradingItem.make!(:segundo_item_pregao_presencial)
    end

    before do
      TradingItemClosing.create!(
        :trading_item_id => closed_item.id,
        :status => TradingItemClosingStatus::ABANDONED)
    end

    it 'should returns the items not closed' do
      expect(described_class.not_closed).to eq [not_closed_item]
    end
  end

  describe '#enabled_bidders_by_lowest_proposal' do
    let(:bidder1) { Bidder.make!(:licitante) }
    let(:bidder2) { Bidder.make!(:licitante_sobrinho) }
    let(:bidder3) { Bidder.make!(:licitante_com_proposta_3) }
    let(:bidder4) { Bidder.make!(:me_pregao) }
    let(:bidder5) { Bidder.make!(:licitante_com_proposta_4) }

    let(:licitation_process) do
      LicitationProcess.make!(:pregao_presencial,
        :bidders => [bidder1, bidder2, bidder3, bidder4, bidder5])
    end

    let(:trading) do
      Trading.make!(:pregao_presencial, :licitation_process => licitation_process)
    end

    subject do
      trading.items.first
    end

    before do
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      # bidder not selected due to too high value
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder2.id,
        :trading_item_id => subject.id,
        :amount => 1000.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder3.id,
        :trading_item_id => subject.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder4.id,
        :trading_item_id => subject.id,
        :amount => 99.5,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder5.id,
        :trading_item_id => subject.id,
        :amount => 99.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 98.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder3.id,
        :trading_item_id => subject.id,
        :amount => 97.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder4.id,
        :trading_item_id => subject.id,
        :amount => 96.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder5.id,
        :trading_item_id => subject.id,
        :amount => 95.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 94.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder3.id,
        :trading_item_id => subject.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder4.id,
        :trading_item_id => subject.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder5.id,
        :trading_item_id => subject.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      BidderDisqualification.create!(:bidder_id => bidder1.id, :reason => 'inabilitado')
    end

    context 'without filter' do
      it 'should fitler bidders with proposal, enabled and order them by amount' do
        expect(subject.enabled_bidders_by_lowest_proposal).to eq [bidder5, bidder4, bidder3, bidder2]
      end
    end

    context 'with selected' do
      it 'should fitler bidders with proposal, enabled and order them by amount' do
        expect(subject.enabled_bidders_by_lowest_proposal(:filter => :selected)).to eq [bidder5, bidder4, bidder3]
      end
    end

    context 'with not selected' do
      it 'should fitler bidders with proposal, enabled and order them by amount' do
        expect(subject.enabled_bidders_by_lowest_proposal(:filter => :not_selected)).to eq [bidder2]
      end
    end
  end

  describe '#disabled_bidders_by_lowest_proposal' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:bidder1) { trading.bidders.first }
    let(:bidder2) { trading.bidders.second }
    let(:bidder3) { trading.bidders.last }

    subject do
      trading.items.first
    end

    before do
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      # bidder not selected due to too high value
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder2.id,
        :trading_item_id => subject.id,
        :amount => 1000.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder3.id,
        :trading_item_id => subject.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 97.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder3.id,
        :trading_item_id => subject.id,
        :amount => 95.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 94.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder3.id,
        :trading_item_id => subject.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      BidderDisqualification.create!(:bidder_id => bidder1.id, :reason => 'inabilitado')
      BidderDisqualification.create!(:bidder_id => bidder3.id, :reason => 'inabilitado')
    end

    it 'should get disabled bidders with proposal ordered by amount' do
      expect(subject.disabled_bidders_by_lowest_proposal).to eq [bidder1, bidder3]
    end
  end

  describe '#bidders_by_lowest_proposal' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:bidder1) { trading.bidders.first }
    let(:bidder2) { trading.bidders.second }
    let(:bidder3) { trading.bidders.last }

    subject do
      trading.items.first
    end

    before do
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      # bidder not selected due to too high value
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder2.id,
        :trading_item_id => subject.id,
        :amount => 1000.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder3.id,
        :trading_item_id => subject.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 97.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder3.id,
        :trading_item_id => subject.id,
        :amount => 95.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 94.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder3.id,
        :trading_item_id => subject.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      BidderDisqualification.create!(:bidder_id => bidder1.id, :reason => 'inabilitado')
      BidderDisqualification.create!(:bidder_id => bidder3.id, :reason => 'inabilitado')
    end

    it 'should get bidders with proposal ordered by amount' do
      expect(subject.bidders_by_lowest_proposal).to eq [bidder1, bidder3, bidder2]
    end

  end
end
