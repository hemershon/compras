class AdministrativeProcessBudgetAllocationItemDecorator < Decorator
  attr_modal :material, :quantity, :unit_price

  def total_price
    helpers.number_to_currency super if super
  end

  def winner_proposals_unit_price
    helpers.number_with_precision(super) if super
  end

  def winner_proposals_total_price
    helpers.number_with_precision(super) if super
  end
end
