class Property < ActiveRecord::Base
  attr_readonly :property_registration

  attr_modal :property_registration, :owner

  has_many :owners, :dependent => :restrict
  has_many :providers, :dependent => :restrict

  delegate :id, :to => :owner, :prefix => true, :allow_nil => true

  orderize :property_registration
  filterize

  def owner
    owners.first.person if owners.first
  end

  def to_s
    property_registration
  end
end
