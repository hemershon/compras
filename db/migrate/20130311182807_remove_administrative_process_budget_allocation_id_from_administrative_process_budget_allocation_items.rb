class RemoveAdministrativeProcessBudgetAllocationIdFromAdministrativeProcessBudgetAllocationItems < ActiveRecord::Migration
  def change
    remove_column :compras_administrative_process_budget_allocation_items, :administrative_process_budget_allocation_id
  end
end