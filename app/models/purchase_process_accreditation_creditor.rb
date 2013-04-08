class PurchaseProcessAccreditationCreditor < Compras::Model
  attr_accessible :purchase_process_accreditation_id, :creditor_id, :company_size_id,
                  :creditor_representative_id, :kind, :has_power_of_attorney

  has_enumeration_for :kind, :with => PurchaseProcessAccreditationCreditorKind

  belongs_to :purchase_process_accreditation
  belongs_to :creditor
  belongs_to :company_size
  belongs_to :creditor_representative

  delegate :personable_type_humanize,
           :to => :creditor, :allow_nil => true, :prefix => true

  validates :kind, :creditor, :company_size, :presence => true
end