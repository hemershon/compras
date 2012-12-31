class PurchaseSolicitationBudgetAllocationItemStatusChanger
  # Change the status of purchase solicitation budget allocation item.
  #
  #   The new purchase solicitation
  #
  #   options - a hash that contains the new and old purchase solicitation ids [:new_ids, :old_ids]
  #
  # Examples:
  #
  #   PurchaseSolicitationBudgetAllocationItemStatusChanger.new(:new_item_ids => new_item_ids).change
  #   PurchaseSolicitationBudgetAllocationItemStatusChanger.new(:new_item_ids => new_item_ids, :old_items_ids => old_items_ids).change
  #   PurchaseSolicitationBudgetAllocationItemStatusChanger.new(:old_items_ids => old_items_ids).change
  def initialize(options = {})
    @new_item_ids = options.fetch(:new_item_ids, [])
    @old_item_ids = options.fetch(:old_item_ids, [])
    @new_purchase_solicitation = options.fetch(:new_purchase_solicitation, nil)
    @old_purchase_solicitation = options.fetch(:old_purchase_solicitation, nil)
    @purchase_solicitation_item_group_id = options.fetch(:purchase_solicitation_item_group_id, nil)
    @new_purchase_solicitation_item_group = options.fetch(:new_purchase_solicitation_item_group, nil)
    @old_purchase_solicitation_item_group = options.fetch(:old_purchase_solicitation_item_group, nil)
  end

  def change(item_repository = PurchaseSolicitationBudgetAllocationItem)
    item_repository.group!(new_item_ids, purchase_solicitation_item_group_id) if new_item_ids.any?

    item_repository.pending!(removed_item_ids) if old_item_ids.any?

    new_purchase_solicitation.attend_items! if new_purchase_solicitation

    old_purchase_solicitation.rollback_attended_items! if old_purchase_solicitation

    new_purchase_solicitation_item_group.attend_items! if new_purchase_solicitation_item_group

    old_purchase_solicitation_item_group.rollback_attended_items! if old_purchase_solicitation_item_group
  end

  private

  attr_reader :new_item_ids, :old_item_ids, :new_purchase_solicitation,
              :old_purchase_solicitation, :purchase_solicitation_item_group_id,
              :new_purchase_solicitation_item_group, :old_purchase_solicitation_item_group

  def removed_item_ids
    old_item_ids - new_item_ids
  end
end
