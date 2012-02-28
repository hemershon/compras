# encoding: utf-8
BudgetAllocation.blueprint(:alocacao) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  organogram { Organogram.make!(:secretaria_de_educacao) }
  subfunction { Subfunction.make!(:geral) }
  government_program { GovernmentProgram.make!(:habitacao) }
  government_action { GovernmentAction.make!(:governamental) }
  expense_economic_classification { ExpenseEconomicClassification.make!(:vencimento_e_salarios) }
  capability { Capability.make!(:reforma) }
  description { "Alocação" }
  goal { 'Manutenção da Unidade Administrativa' }
  debt_type { DebtType::NOTHING }
  budget_allocation_type { BudgetAllocationType.make!(:administrativa) }
  refinancing { true }
  health { false }
  alienation_appeal { false }
  education { false }
  foresight { false }
  personal { false }
  date { Date.current }
  amount { "500,00" }
end

BudgetAllocation.blueprint(:alocacao_extra) do
  entity { Entity.make!(:detran) }
  year { 2011 }
  organogram { Organogram.make!(:secretaria_de_educacao) }
  subfunction { Subfunction.make!(:geral) }
  government_program { GovernmentProgram.make!(:habitacao) }
  government_action { GovernmentAction.make!(:governamental) }
  expense_economic_classification { ExpenseEconomicClassification.make!(:vencimento_e_salarios) }
  capability { Capability.make!(:reforma) }
  description { "Alocação extra" }
  goal { 'Manutenção da Unidade Administrativa' }
  debt_type { DebtType::NOTHING }
  budget_allocation_type { BudgetAllocationType.make!(:administrativa) }
  refinancing { true }
  health { false }
  alienation_appeal { false }
  education { false }
  foresight { false }
  personal { false }
  amount { "200,00" }
  date { Date.current }
end

BudgetAllocation.blueprint(:conserto) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  organogram { Organogram.make!(:secretaria_de_educacao) }
  subfunction { Subfunction.make!(:geral) }
  government_program { GovernmentProgram.make!(:habitacao) }
  government_action { GovernmentAction.make!(:governamental) }
  expense_economic_classification { ExpenseEconomicClassification.make!(:vencimento_e_salarios) }
  capability { Capability.make!(:reforma) }
  description { "Conserto" }
  goal { 'Manutenção da Unidade Administrativa' }
  debt_type { DebtType::NOTHING }
  budget_allocation_type { BudgetAllocationType.make!(:administrativa) }
  refinancing { true }
  health { false }
  alienation_appeal { false }
  education { false }
  foresight { false }
  personal { false }
  date { Date.current }
  amount { "300,00" }
end

BudgetAllocation.blueprint(:reparo_2011) do
  entity { Entity.make!(:secretaria_de_educacao) }
  year { 2011 }
  organogram { Organogram.make!(:secretaria_de_desenvolvimento) }
  subfunction { Subfunction.make!(:supervisor) }
  government_program { GovernmentProgram.make!(:educacao) }
  government_action { GovernmentAction.make!(:nacional) }
  expense_economic_classification { ExpenseEconomicClassification.make!(:compra_de_material) }
  capability { Capability.make!(:reforma) }
  description { "Manutenção e Reparo" }
  goal { 'Manutenção da Unidade Administrativa' }
  debt_type { DebtType::NOTHING }
  budget_allocation_type { BudgetAllocationType.make!(:administrativa) }
  refinancing { true }
  health { false }
  alienation_appeal { false }
  education { false }
  foresight { false }
  personal { false }
  date { Date.current }
  amount { "3000,00" }
end
