class TradingItemBidsController < CrudController
  def new
    object = build_resource
    object.trading_item = @parent
    object.round  = TradingItemBidRoundCalculator.new(@parent).calculate
    object.bidder = TradingItemBidBidderChooser.new(@parent).choose
    object.status = TradingItemBidStatus::WITH_PROPOSAL
    object.amount = 0

    super
  end

  def create
    create! { after_creation_redirect_path }
  end

  protected

  def create_resource(object)
    object.round  = TradingItemBidRoundCalculator.new(@parent).calculate
    object.bidder = TradingItemBidBidderChooser.new(@parent).choose

    super
  end

  def begin_of_association_chain
    @parent = get_parent
  end

  def get_parent
    if parent_id
      @parent = TradingItem.find(parent_id)
    end
  end

  def parent_id
    params[:trading_item_id] || params[:trading_item_bid][:trading_item_id]
  end

  def after_creation_redirect_path
    if @parent.finished_bid_stage?
      classification_trading_item_path(@parent)
    else
      new_trading_item_bid_path(:trading_item_id => resource.trading_item_id)
    end
  end
end
