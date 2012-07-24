class PledgeBudgetAllocationSubtractor
  attr_accessor :pledge, :budget_allocation

  def initialize(pledge)
    self.pledge = pledge
    self.budget_allocation = pledge.budget_allocation
  end

  def subtract_budget_allocation_amount!
    return unless budget_allocation

    budget_allocation.update_column(:amount, budget_allocation.amount - pledge.value)
  end
end
