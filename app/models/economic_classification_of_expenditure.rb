class EconomicClassificationOfExpenditure < ActiveRecord::Base
  attr_accessible :entity_id, :administractive_act_id
  attr_accessible :economic_classification_of_expenditure, :kind
  attr_accessible :description, :docket

  validates :economic_classification_of_expenditure, :kind, :description, :presence => true
  validates :economic_classification_of_expenditure, :mask => '9.9.99.99.99.99.99.99'

  has_enumeration_for :kind, :with => EconomicClassificationOfExpenditureKind, :create_helpers => true


  belongs_to :entity
  belongs_to :administractive_act

  orderize :description
  filterize

  def to_s
    economic_classification_of_expenditure
  end
end
