class TradingItemDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def unit_price
    number_with_precision super if super
  end

  def quantity
    number_with_precision super if super
  end

  def trading_item_bid_or_classification_path(options={})
    stage_calculator = options.fetch(:stage_calculator) { TradingItemBidStageCalculator.new(component) }

    if stage_calculator.stage_of_negotiation? && (trading_item_bids.negotiation.empty? || valid_negotiation_proposals.any?)
      routes.classification_trading_item_path(component)
    else
      routes.new_trading_item_bid_path(:trading_item_id => component.id, :anchor => :title)
    end
  end

  def trading_item_bid_or_classification_or_report_classification_path(stage_calculator = TradingItemBidStageCalculator)
    if stage_calculator.new(component).show_proposal_report?
      routes.proposal_report_trading_item_path(component)
    else
      trading_item_bid_or_classification_path
    end
  end

  def situation_for_next_stage(bidder)
    if bidder_selected?(bidder)
      t('trading_item.messages.selected')
    else
      t('trading_item.messages.not_selected')
    end
  end

  def allows_offer_placing
    must_have_minimum_reduction || must_be_open
  end

  private

  def must_have_minimum_reduction
    return if minimum_reduction_percent > 0 || minimum_reduction_value > 0

    t('trading_item.messages.must_have_reduction')
  end

  def must_be_open
    return unless closed?

    t('trading_item.messages.must_be_open')
  end

  def bidder_selected?(bidder)
    bidders_with_proposal_for_proposal_stage_with_amount_lower_than_limit.include? bidder
  end

  def value_limit_to_participate_in_bids
    component.value_limit_to_participate_in_bids
  end

  def bidders_with_proposal_for_proposal_stage_with_amount_lower_than_limit
    component.bidders.with_proposal_for_proposal_stage_with_amount_lower_than_limit(value_limit_to_participate_in_bids)
  end
end
