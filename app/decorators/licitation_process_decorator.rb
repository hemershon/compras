class LicitationProcessDecorator < Decorator
  attr_modal :process, :year, :process_date, :licitation_number, :administrative_process

  def envelope_delivery_time
    helpers.l(component.envelope_delivery_time, :format => :hour) if component.envelope_delivery_time
  end

  def envelope_opening_time
    helpers.l(component.envelope_opening_time, :format => :hour) if component.envelope_opening_time
  end

  def count_link
    return unless component.persisted?

    helpers.link_to('Apurar', routes.licitation_process_path(component), :class => "button primary") if component.envelope_opening?
  end

  def lots_link
    helpers.link_to('Lotes de itens', routes.licitation_process_licitation_process_lots_path(component), :class => "button primary")
  end

  def winner_proposal_total_price
    helpers.number_to_currency component.winner_proposal_total_price if component.winner_proposal_total_price
  end
end
