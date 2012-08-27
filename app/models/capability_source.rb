class CapabilitySource < Compras::Model
  attr_accessible :code, :name, :source, :specification

  has_enumeration_for :source

  has_many :tce_specification_capabilities

  validates :code, :name, :specification, :source, :presence => true
  validates :code, :uniqueness => true, :allow_blank => true

  orderize
  filterize

  def to_s
    name
  end
end