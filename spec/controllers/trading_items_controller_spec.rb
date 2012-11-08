require 'spec_helper'

describe TradingItemsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'PUT #update' do
    it 'should redirect to trading item list when editted' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.trading_items.first

      subject.should_receive(:parent).and_return(trading)

      put :update, :id => item.id, :trading_item => item.attributes

      expect(response).to redirect_to(trading_items_path(:trading_id => trading.id))
    end
  end
end
