# encoding: utf-8
PurchaseSolicitation.blueprint(:reparo) do
  accounting_year { "2012" }
  request_date { "2012-01-31" }
  responsible { Employee.make!(:sobrinho) }
  justification { "Reparo nas instalações" }
  delivery_location { DeliveryLocation.make!(:education) }
  kind { "goods" }
  general_observations { "Reparos nas instalações superiores" }
  service_status { "pending" }
  liberation_date { "2012-01-31" }
  liberator { Employee.make!(:sobrinho) }
  service_observations { "Pronto" }
  no_service_justification { "n/a" }
end

PurchaseSolicitation.blueprint(:conserto) do
  accounting_year { "2012" }
  request_date { "2012-01-31" }
  responsible { Employee.make!(:wenderson) }
  justification { "Reparo nas instalações" }
  purchase_solicitation_budget_allocations {
    [PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria),
     PurchaseSolicitationBudgetAllocation.make!(:alocacao_secundaria)] }
  delivery_location { DeliveryLocation.make!(:education) }
  kind { "goods" }
  general_observations { "Reparos nas instalações superiores" }
  service_status { "pending" }
  liberation_date { "2012-01-31" }
  liberator { Employee.make!(:sobrinho) }
  service_observations { "Pronto" }
  no_service_justification { "n/a" }
end
