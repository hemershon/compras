class PurchaseProcessTrading < Compras::Model
  attr_accessible :purchase_process_id, :items_attributes

  belongs_to :purchase_process, class_name: 'LicitationProcess'

  has_many :purchase_process_accreditation_creditors, through: :purchase_process_accreditation
  has_many :creditors, through: :purchase_process_accreditation_creditors
  has_many :items, class_name: 'PurchaseProcessTradingItem', foreign_key: :trading_id

  has_one :judgment_form, through: :purchase_process
  has_one :purchase_process_accreditation, through: :purchase_process

  accepts_nested_attributes_for :items, allow_destroy: true

  delegate :kind, :kind_humanize, to: :judgment_form, allow_nil: true

  validates :purchase_process, presence: true
end
