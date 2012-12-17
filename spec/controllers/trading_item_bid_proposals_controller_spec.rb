# encoding: utf-8
require 'spec_helper'

describe TradingItemBidProposalsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET new' do
    it 'assigns the parent trading item to the bid' do
      trading_item = TradingItem.make!(:item_pregao_presencial)

      get :new, :trading_item_id => trading_item.id

      expect(assigns(:trading_item_bid).trading_item).to eq trading_item
      expect(assigns(:trading_item_bid).amount).to eq 0
      expect(assigns(:trading_item_bid).bidder).to eq trading_item.bidders.first
      expect(assigns(:trading_item_bid).status).to eq TradingItemBidStatus::WITH_PROPOSAL
    end
  end

  describe 'POST #create' do
    it 'create and bid without proposal' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      post :create, :trading_id => trading.id,
           :trading_item_bid => {
             :trading_item_id => trading_item.id,
             :status => TradingItemBidStatus::WITHOUT_PROPOSAL
           }

      expect(assigns(:trading_item_bid).status).to eq TradingItemBidStatus::WITHOUT_PROPOSAL
      expect(assigns(:trading_item_bid).stage).to eq TradingItemBidStage::PROPOSALS
      expect(assigns(:trading_item_bid).round).to eq 0
    end

    it 'should render 404 when all bidder have proposals' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 120.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 120.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder3.id,
        :amount => 120.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)


      post :create, :trading_id => trading.id,
           :trading_item_bid => {
             :trading_item_id => trading_item.id,
             :status => TradingItemBidStatus::WITHOUT_PROPOSAL
           }

      expect(response.code).to eq '404'
      expect(response.body).to match /A página que você procura não existe/
    end

    it 'should redirect to proposal_report after create the last proposal' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 120.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 120.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      post :create, :trading_id => trading.id,
           :trading_item_bid => {
             :trading_item_id => trading_item.id,
             :amount => 100.0,
             :status => TradingItemBidStatus::WITHOUT_PROPOSAL
           }

      expect(response).to redirect_to(proposal_report_trading_item_path(trading_item))
    end

    it 'should redirect to new trading item bid after create when is on stage of round of bids' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 120.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      post :create, :trading_id => trading.id,
           :trading_item_bid => {
             :trading_item_id => trading_item.id,
             :amount => 100.0,
             :status => TradingItemBidStatus::WITHOUT_PROPOSAL
           }

      expect(response).to redirect_to(new_trading_item_bid_proposal_path(:trading_item_id => trading_item.id, :anchor => :title))
    end
  end
end
