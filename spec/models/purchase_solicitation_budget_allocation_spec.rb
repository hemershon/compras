require 'model_helper'
require 'app/models/purchase_solicitation_budget_allocation'

describe PurchaseSolicitationBudgetAllocation do
  it { should validate_presence_of :budget_allocation_id }
  it { should validate_presence_of :estimated_value }
  it { should belong_to :purchase_solicitation }
  it { should belong_to :budget_allocation }
end
