# encoding: utf-8
ReserveFund.blueprint(:detran_2012) do
  descriptor { Descriptor.make!(:detran_2012) }
  status { ReserveFundStatus::RESERVED }
  reserve_allocation_type { ReserveAllocationType.make!(:licitation) }
  date { Date.new(2012, 2, 22) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 10.5 }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_number { "001" }
  licitation_year { "2012" }
  process_number { "002" }
  process_year { "2013" }
  creditor { Creditor.make!(:wenderson_sa) }
  reason { 'Motivo para a reserva de dotação' }
end

ReserveFund.blueprint(:educacao_2011) do
  descriptor { Descriptor.make!(:secretaria_de_educacao_2011) }
  status { ReserveFundStatus::RESERVED }
  reserve_allocation_type { ReserveAllocationType.make!(:comum) }
  date { Date.new(2012, 2, 21) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 100.5 }
  process_number { "002" }
  process_year { "2013" }
  creditor { Creditor.make!(:wenderson_sa) }
  reason { 'Motivo para a reserva de dotação' }
end

ReserveFund.blueprint(:reparo_2011) do
  descriptor { Descriptor.make!(:secretaria_de_educacao_2011) }
  status { ReserveFundStatus::RESERVED }
  reserve_allocation_type { ReserveAllocationType.make!(:comum) }
  date { Date.new(2012, 2, 21) }
  budget_allocation { BudgetAllocation.make!(:reparo_2011) }
  value { 100.5 }
  process_number { "002" }
  process_year { "2013" }
  creditor { Creditor.make!(:wenderson_sa) }
  reason { 'Motivo para a reserva de dotação' }
end

ReserveFund.blueprint(:detran_2011) do
  descriptor { Descriptor.make!(:detran_2011) }
  status { ReserveFundStatus::RESERVED }
  reserve_allocation_type { ReserveAllocationType.make!(:licitation) }
  date { Date.new(2012, 2, 21) }
  value { 10.5 }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_number { "001" }
  licitation_year { "2012" }
  process_number { "002" }
  process_year { "2013" }
  creditor { Creditor.make!(:wenderson_sa) }
  reason { 'Motivo para a reserva de dotação' }
end
