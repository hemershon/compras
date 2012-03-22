class ExpenseEconomicClassification < ActiveRecord::Base
  attr_accessible :entity_id, :administractive_act_id
  attr_accessible :expense_economic_classification, :kind
  attr_accessible :description, :docket

  attr_modal :expense_economic_classification, :description, :entity_id
  attr_modal :administractive_act_id, :kind

  has_enumeration_for :kind, :with => ExpenseEconomicClassificationKind, :create_helpers => true

  belongs_to :entity
  belongs_to :administractive_act

  has_many :purchase_solicitations, :dependent => :restrict
  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :materials, :dependent => :restrict
  has_many :budget_allocations, :dependent => :restrict

  validates :expense_economic_classification, :kind, :description, :presence => true
  validates :expense_economic_classification, :mask => '9.9.99.99.99.99.99.99'

  orderize :description
  filterize

  def to_s
    expense_economic_classification
  end
end
