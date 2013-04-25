json.array!(collection) do |json, obj|
  json.id                obj.id
  json.value             obj.to_s
  json.label             obj.to_s
  json.code_and_year     obj.decorator.code_and_year
  json.budget_structure  obj.budget_structure.to_s
  json.responsible       obj.responsible.to_s
  json.total_items_value obj.total_items_value.to_f

  json.budget_allocations obj.purchase_solicitation_budget_allocations do |json, psba|
    json.id                                  psba.id
    json.to_s                                psba.to_s
    json.budget_allocation                   psba.budget_allocation.to_s
    json.budget_allocation_id                psba.budget_allocation_id
    json.budget_allocation_expense_nature    psba.budget_allocation.expense_nature.to_s
    json.budget_allocation_expense_nature_id psba.budget_allocation.expense_nature_id
    json.expense_nature                      psba.expense_nature.to_s
    json.expense_nature_id                   psba.expense_nature_id.to_s
    json.amount                              psba.budget_allocation.amount.to_f
    json.estimated_value                     psba.estimated_value.to_f
  end

  json.items obj.items do |json, item|
    json.id                    item.id
    json.material_id           item.material_id
    json.material_description  item.material.to_s
    json.brand                 item.brand
    json.reference_unit        item.reference_unit.acronym
    json.quantity              item.quantity.to_f
    json.unit_price            item.unit_price.to_f
    json.estimated_total_price item.estimated_total_price.to_f
  end
end
