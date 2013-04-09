class AdministrativeProcessBudgetAllocation < Compras::Model
  attr_accessible :licitation_process_id, :budget_allocation_id, :value,
                  :expense_nature_split_id

  attr_modal :material, :quantity, :unit_price

  belongs_to :licitation_process
  belongs_to :budget_allocation
  belongs_to :expense_nature_split, :class_name => "ExpenseNature"

  delegate :expense_nature, :amount,
           :to => :budget_allocation, :allow_nil => true, :prefix => true

  validates :budget_allocation, :value, :presence => true
end
