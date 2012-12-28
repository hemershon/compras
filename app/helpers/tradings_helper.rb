#encoding: utf-8
module TradingsHelper
  def content_preamble
    t('trading.messages.content_preamble',
      :created_at_to_date => created_at_to_date,
      :created_at_hour => created_at_hour,
      :auctioneer => auctioneer,
      :support_team => support_team
     )
  end

  def closing_of_accreditation
    t('trading.messages.closing_of_accreditation')
  end

  def trading_registry
    t('trading.messages.trading_registry')
  end

  private
  def created_at_to_date
    return unless resource.persisted?

    I18n.l(resource.created_at.to_date, :format => :long)
  end

  def created_at_hour
    return unless resource.persisted?

    I18n.l(resource.created_at, :format => :hour)
  end

  def auctioneer
    return unless resource.persisted? && resource.auctioneer

    resource.auctioneer.first
  end

  def support_team
    return unless resource.persisted? && resource.support_team

    resource.support_team.join ','
  end
end