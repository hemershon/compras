class ExpenseNaturePresenter < Presenter::Proxy
  attr_modal :full_code, :description, :entity_id, :regulatory_act_id, :kind
end
