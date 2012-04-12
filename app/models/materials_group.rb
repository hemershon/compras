class MaterialsGroup < ActiveRecord::Base
  attr_accessible :group_number, :description

  has_and_belongs_to_many :providers

  has_many :materials_classes, :dependent => :restrict
  has_many :materials, :through => :materials_classes

  validates :description, :group_number, :presence => true, :uniqueness => { :allow_blank => true }
  validates :group_number, :numericality => true, :mask => '99', :allow_blank => true

  orderize :description
  filterize

  def to_s
    "#{group_number} - #{description}"
  end
end
