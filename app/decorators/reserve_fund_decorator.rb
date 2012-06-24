class ReserveFundDecorator < Decorator
  attr_modal :date, :licitation_modality_id, :creditor_id, :status
  attr_modal :descriptor_id, :budget_allocation_id, :reserve_allocation_type_id

  def budget_allocation_real_amount
    helpers.number_with_precision super if super
  end
end
