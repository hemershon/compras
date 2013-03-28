# encoding: utf-8
PurchaseSolicitationBudgetAllocation.blueprint(:alocacao_primaria) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  expense_nature { ExpenseNature.make!(:compra_de_material) }
  blocked { false }
end

PurchaseSolicitationBudgetAllocation.blueprint(:alocacao_primaria_2013) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  expense_nature { ExpenseNature.make!(:compra_de_material) }
  blocked { false }
end

PurchaseSolicitationBudgetAllocation.blueprint(:alocacao_primaria_office) do
  budget_allocation { BudgetAllocation.make!(:alocacao_extra) }
  expense_nature { ExpenseNature.make!(:compra_de_material) }
  blocked { false }
end
