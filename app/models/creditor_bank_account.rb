class CreditorBankAccount < Compras::Model
  attr_accessible :creditor_id, :agency_id, :status, :account_type
  attr_accessible :number, :digit

  has_enumeration_for :status
  has_enumeration_for :account_type

  belongs_to :creditor
  belongs_to :agency

  delegate :bank, :bank_id, :to => :agency, :allow_nil => true

  validates :creditor, :agency, :status, :account_type, :digit, :presence => true
  validates :number, :presence => true, :uniqueness => { :scope => :agency_id }

  def to_s
    "#{number}-#{digit}"
  end
end
