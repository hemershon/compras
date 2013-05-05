class TradingBidRemover
  def initialize(item)
    @item = item
  end

  def self.undo(*args)
    new(*args).undo_last_bid
  end

  def undo_last_bid
    return unless last_bid

    last_bid.update_attributes(
      status: TradingItemBidStatus::WITHOUT_PROPOSAL,
      amount: 0)
  end

  private

  def last_bid
    @item.last_trading_bid
  end
end
