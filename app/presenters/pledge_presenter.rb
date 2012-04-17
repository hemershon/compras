class PledgePresenter < Presenter::Proxy
  attr_modal :entity_id, :year, :emission_date

  attr_data 'id' => :id, 'emission-date' => :emission_date, 'pledge-value' => :value

  def budget_allocation_real_ammount
    helpers.number_with_precision object.budget_allocation_real_ammount
  end

  def reserve_found_value
    helpers.number_with_precision object.reserve_found_value
  end
end
