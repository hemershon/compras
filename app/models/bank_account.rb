class BankAccount < Compras::Model
  attr_accessible :description, :agency_id, :account_number, :status, :kind,
                  :digit, :bank, :bank_id, :capabilities_attributes

  attr_modal :description, :agency_id, :account_number

  attr_writer :bank, :bank_id

  has_enumeration_for :status
  has_enumeration_for :kind, :with => BankAccountKind

  belongs_to :agency

  has_many :capabilities, :dependent => :destroy, :class_name => 'BankAccountCapability',
           :order => [BankAccountCapability.arel_table[:status], BankAccountCapability.arel_table[:id]]

  accepts_nested_attributes_for :capabilities, :allow_destroy => true

  delegate :number, :digit, :to => :agency, :allow_nil => true, :prefix => true

  validates :description, :agency, :kind, :account_number, :digit,
            :presence => true
  validates :account_number, :numericality => true
  validates :description, :uniqueness => { :scope => :agency_id },
            :allow_blank => true

  orderize :account_number
  filterize

  def to_s
    description
  end

  def bank
    agency.try(:bank) || @bank
  end

  def bank_id
    agency.try(:bank_id) || @bank_id
  end

  def capabilities_without_status
    capabilities.select { |c| c.status.nil? }
  end

  def first_capability_without_status
    capabilities_without_status.try(:first)
  end
end
