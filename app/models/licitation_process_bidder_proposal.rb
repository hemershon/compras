class LicitationProcessBidderProposal < Compras::Model
  attr_accessible :licitation_process_bidder, :administrative_process_budget_allocation_item, :brand, :unit_price
  attr_accessible :licitation_process_bidder_id, :administrative_process_budget_allocation_item_id

  has_enumeration_for :situation, :with => SituationOfProposal

  has_one :licitation_process_lot, :through => :administrative_process_budget_allocation_item
  belongs_to :licitation_process_bidder
  belongs_to :administrative_process_budget_allocation_item

  delegate :material, :quantity, :to => :administrative_process_budget_allocation_item, :allow_nil => true
  delegate :reference_unit, :to => :material, :allow_nil => true
  delegate :provider, :to => :licitation_process_bidder, :allow_nil => true

  def total_price
    return 0 unless quantity && unit_price
    quantity * unit_price
  end
end
