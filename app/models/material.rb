class Material < ActiveRecord::Base
  attr_accessible :materials_class_id, :code, :description, :material_type
  attr_accessible :detailed_description, :minimum_stock_balance
  attr_accessible :reference_unit_id, :manufacturer, :perishable, :storable
  attr_accessible :service_or_contract_type_id, :expense_economic_classification_id
  attr_accessible :combustible, :material_characteristic

  attr_modal :description

  has_enumeration_for :material_characteristic, :create_helpers => true
  has_enumeration_for :material_type, :create_helpers => true

  belongs_to :materials_class
  belongs_to :reference_unit
  belongs_to :service_or_contract_type
  belongs_to :expense_economic_classification

  has_and_belongs_to_many :providers
  has_and_belongs_to_many :licitation_objects

  has_many :pledge_items, :dependent => :restrict
  has_many :direct_purchase_budget_allocation_items, :dependent => :restrict
  has_many :licitation_process_budget_allocation_items, :dependent => :restrict

  delegate :materials_group, :materials_group_id, :to => :materials_class, :allow_nil => true

  validates :materials_group, :materials_class, :reference_unit, :presence => true
  validates :material_characteristic, :presence => true
  validates :code, :description, :presence => true, :uniqueness => true
  validates :material_type, :presence => true, :if => :material?
  validates :service_or_contract_type, :presence => true, :if => :service?

  before_save :clean_unnecessary_type

  orderize :description
  filterize

  scope :licitation_object_id, lambda { |licitation_object_id|
    joins(:licitation_objects).where { licitation_objects.id.eq(licitation_object_id) }
  }

  def self.last_by_materials_class_and_group(params = {})
    record = scoped
    record = record.where { materials_class_id.eq(params.fetch(:materials_class_id)) }
    record = record.order { code }.last
    record
  end

  def to_s
    "#{code} - #{description}"
  end

  protected

  def clean_unnecessary_type
    if material?
      self.service_or_contract_type_id = nil
    elsif service?
      self.material_type = nil
    end
  end
end
