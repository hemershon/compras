# encoding: UTF-8
require 'spec_helper'

describe Bidder do
  context 'uniqueness validations' do
    before { LicitationProcess.make!(:processo_licitatorio_computador) }

    it { should validate_uniqueness_of(:creditor_id).scoped_to(:licitation_process_id) }
  end

  describe '.with_proposal_for_trading_item_round' do
    it 'should return all bidders with proposal for a specifc round' do
      sobrinho = Bidder.make!(:licitante_sobrinho)
      wenderson = Bidder.make!(:licitante)

      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson])

      trading_item = TradingItem.make!(:item_pregao_presencial)

      Trading.make!(
        :pregao_presencial,
        :items => [trading_item],
        :licitation_process => licitation_process)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => sobrinho.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => wenderson.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      expect(described_class.with_proposal_for_trading_item_round(1)).to eq [sobrinho]
    end

    it 'should return an empty array if round there are no bidder proposal' do
      sobrinho = Bidder.make!(:licitante_sobrinho)
      wenderson = Bidder.make!(:licitante)

      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson])

      trading_item = TradingItem.make!(:item_pregao_presencial)

      Trading.make!(
        :pregao_presencial,
        :items => [trading_item],
        :licitation_process => licitation_process)

      expect(described_class.with_proposal_for_trading_item_round(1)).to eq []
    end
  end

  describe '.at_bid_round' do
    it 'should return only bidders for that specific round' do
      sobrinho = Bidder.make!(:licitante_sobrinho)
      wenderson = Bidder.make!(:licitante)

      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson])

      trading_item = TradingItem.make!(:item_pregao_presencial)

      Trading.make!(
        :pregao_presencial,
        :items => [trading_item],
        :licitation_process => licitation_process)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => sobrinho.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      expect(described_class.at_bid_round(1, trading_item.id)).to eq [sobrinho]
    end
  end

  describe '.with_proposal_for_trading_item' do
    it 'should return only bidders with proposal for a specific trading item' do
      trading_item_with_proposal = TradingItem.make!(:item_pregao_presencial)
      trading_item_without_proposal = TradingItem.make!(:item_pregao_presencial, :minimum_reduction_value => 0.02)

      trading = Trading.make!(:pregao_presencial,
        :items => [trading_item_with_proposal,trading_item_without_proposal])

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder1.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_without_proposal.id,
        :bidder_id => bidder2.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder3.id,
        :amount => 0.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      expect(described_class.with_proposal_for_trading_item(trading_item_with_proposal.id)).to eq [bidder1]
    end
  end

  describe '.with_proposal_for_trading_item_at_stage_of_round_of_bids' do
    it 'should return only bidders with proposal at stage of round of bids for a specific trading item' do
      trading_item_with_proposal = TradingItem.make!(:item_pregao_presencial)
      trading_item_without_proposal = TradingItem.make!(:item_pregao_presencial, :minimum_reduction_value => 0.02)

      trading = Trading.make!(:pregao_presencial,
        :items => [trading_item_with_proposal,trading_item_without_proposal])

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder1.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder2.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder3.id,
        :amount => 80.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      expect(described_class.with_proposal_for_trading_item_at_stage_of_round_of_bids(trading_item_with_proposal.id)).to include(bidder1, bidder3)
    end
  end

  describe '.with_proposal_for_trading_item_at_stage_of_negotiation' do
    it 'should return only bidders with proposal at stage of negotiation for a specific trading item' do
      trading_item_with_proposal = TradingItem.make!(:item_pregao_presencial)
      trading_item_without_proposal = TradingItem.make!(:item_pregao_presencial, :minimum_reduction_value => 0.02)

      trading = Trading.make!(:pregao_presencial,
        :items => [trading_item_with_proposal,trading_item_without_proposal])

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder1.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder2.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::NEGOTIATION,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder3.id,
        :amount => 80.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      expect(described_class.with_proposal_for_trading_item_at_stage_of_negotiation(trading_item_with_proposal.id)).to eq [bidder2]
    end
  end

  describe '.at_round_of_bids' do
    before do
      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson, nohup])

      trading = Trading.make!(:pregao_presencial,
        :items =>[trading_item],
        :licitation_process => licitation_process
      )

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => sobrinho.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => wenderson.id,
        :amount => 99.99,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => nohup.id,
        :amount => 98.0,
        :stage => TradingItemBidStage::NEGOTIATION,
        :status => TradingItemBidStatus::WITH_PROPOSAL)
    end

    let(:trading_item) { TradingItem.make!(:item_pregao_presencial) }
    let(:sobrinho) { Bidder.make!(:licitante_sobrinho) }
    let(:wenderson) { Bidder.make!(:licitante) }
    let(:nohup) { Bidder.make!(:licitante_com_proposta_3) }


    it 'should return only bidders for the stage of round_of_bids of the trading item' do
      expect(described_class.at_round_of_bids(trading_item.id)).to eq [wenderson]
    end
  end

  describe '#lower_trading_item_bid_amount' do
    it 'should return zero when bidder there is no proposal for item' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.items.first
      bidder = trading.bidders.first

      expect(bidder.lower_trading_item_bid_amount(trading_item)).to eq 0
    end

    it 'should return the amount of lowest proposal of bidder for item' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.items.first

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder3.id,
        :amount => 0.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 80.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      expect(bidder1.lower_trading_item_bid_amount(trading_item)).to eq 80.0
    end

    it 'should return zero when bidder have no bid status with_proposal' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.items.first

      bidder = trading.bidders.first

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 10.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      expect(bidder.lower_trading_item_bid_amount(trading_item)).to eq 0.0
    end
  end

  describe '#lower_trading_item_bid_amount_at_stage_of_proposals' do
    it 'should return zero when bidder there is no proposal for item' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.items.first
      bidder = trading.bidders.first

      expect(bidder.lower_trading_item_bid_amount_at_stage_of_proposals(trading_item)).to eq 0
    end

    it 'should return the amount of lowest proposal of bidder for item' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.items.first

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder3.id,
        :amount => 0.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 80.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      expect(bidder1.lower_trading_item_bid_amount_at_stage_of_proposals(trading_item)).to eq 80.0
    end
  end

  describe '#lower_trading_item_bid_amount_at_stage_of_round_of_bids' do
    it 'should return zero when bidder there is no proposal for item' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.items.first
      bidder = trading.bidders.first

      expect(bidder.lower_trading_item_bid_amount_at_stage_of_proposals(trading_item)).to eq 0
    end

    it 'should return the amount of lowest proposal of bidder for item' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.items.first

      bidder = trading.bidders.first

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      expect(bidder.lower_trading_item_bid_amount_at_stage_of_proposals(trading_item)).to eq 100.0
    end
  end

  describe '#lower_trading_item_bid_amount_at_stage_of_negotiation' do
    it 'should return zero when bidder there is no proposal for item' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.items.first
      bidder = trading.bidders.first

      expect(bidder.lower_trading_item_bid_amount_at_stage_of_negotiation(trading_item)).to eq 0
    end

    it 'should return the amount of lowest proposal of bidder for item' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.items.first

      bidder = trading.bidders.first

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 80.0,
        :stage => TradingItemBidStage::NEGOTIATION,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      expect(bidder.lower_trading_item_bid_amount_at_stage_of_negotiation(trading_item)).to eq 80.0
    end
  end

  describe '.benefited' do
    it 'should return only bidders benefited' do
      licitante = Bidder.make!(:licitante)
      licitante_sobrinho = Bidder.make!(:licitante_sobrinho)
      licitante_com_proposta_3 = Bidder.make!(:licitante_com_proposta_3)
      me_pregao = Bidder.make(:me_pregao)

      expect(Bidder.benefited).to eq [licitante_com_proposta_3]
    end
  end

  describe '.eligible_for_negotiation_stage' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:trading_item) { trading.items.first }
    let(:bidder1) { trading.bidders.first }
    let(:bidder2) { trading.bidders.second }
    let(:bidder3) { trading.bidders.last }

    before do
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      # bidder not selected due to too high value
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder2.id,
        :trading_item_id => trading_item.id,
        :amount => 1000.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder3.id,
        :trading_item_id => trading_item.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 97.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder3.id,
        :trading_item_id => trading_item.id,
        :amount => 95.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 94.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder3.id,
        :trading_item_id => trading_item.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      BidderDisqualification.create!(:bidder_id => bidder1.id, :reason => 'inabilitado')
    end

    context 'when trading_item does not activated proposals' do
      it "should returns the bids with proposals for the round of bids with the amout lower than value" do
        expect(described_class.eligible_for_negotiation_stage(95)).to include(bidder3)
        expect(described_class.eligible_for_negotiation_stage(95)).to_not include(bidder1, bidder2)
      end
    end

    context 'when trading_item does activated proposals' do
      before do
        trading_item.update_column(:proposals_activated_at, DateTime.current)
      end

      it "should returns the bids with proposals for the round of bids with the amout lower than value" do
        expect(described_class.eligible_for_negotiation_stage(95)).to include(bidder2, bidder3)
        expect(described_class.eligible_for_negotiation_stage(95)).to_not include(bidder1)
      end
    end
  end

  describe '.ordered_by_trading_item_bid_amount' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:trading_item) { trading.items.first }
    let(:bidder1) { trading.bidders.first }
    let(:bidder2) { trading.bidders.second }
    let(:bidder3) { trading.bidders.last }

    before do
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder2.id,
        :trading_item_id => trading_item.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder3.id,
        :trading_item_id => trading_item.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 97.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder2.id,
        :trading_item_id => trading_item.id,
        :amount => 95.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder3.id,
        :trading_item_id => trading_item.id,
        :amount => 94.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 93.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder2.id,
        :trading_item_id => trading_item.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)
    end

    it 'should return bidders ordered by amount' do
      expect(described_class.ordered_by_trading_item_bid_amount(trading_item.id)).to eq [bidder1, bidder3, bidder2]
    end
  end

  describe '.exclude_ids' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:trading_item) { trading.items.first }
    let(:bidder1) { trading.bidders.first }
    let(:bidder2) { trading.bidders.second }
    let(:bidder3) { trading.bidders.last }

    it 'should exclude bidders with given ids' do
      expect(described_class.exclude_ids([bidder1.id, bidder2.id])).to eq [bidder3]
    end
  end

  describe '.under_limit_value' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:trading_item) { trading.items.first }
    let(:bidder1) { trading.bidders.first }
    let(:bidder2) { trading.bidders.second }
    let(:bidder3) { trading.bidders.last }

    before do
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 105.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder2.id,
        :trading_item_id => trading_item.id,
        :amount => 110.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder3.id,
        :trading_item_id => trading_item.id,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)
    end

    it 'should return none bidders under 99.9' do
      expect(described_class.under_limit_value(trading_item.id, 99.0)).to eq []
    end

    it 'should return one bidder under 100.0' do
      expect(described_class.under_limit_value(trading_item.id, 100.0)).to eq [bidder1]
    end

    it 'should return two bidders under 110.0' do
      expect(described_class.under_limit_value(trading_item.id, 110.0)).to include(bidder1, bidder2)
      expect(described_class.under_limit_value(trading_item.id, 110.0)).to_not include(bidder3)
    end
  end
end
