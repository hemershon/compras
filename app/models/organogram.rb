class Organogram < ActiveRecord::Base
  attr_accessible :name, :organogram, :tce_code, :acronym
  attr_accessible :performance_field, :configuration_organogram_id
  attr_accessible :type_of_administractive_act_id, :address_attributes

  validates :name, :organogram, :tce_code, :acronym, :presence => true
  validates :performance_field, :configuration_organogram_id, :presence => true
  validates :type_of_administractive_act_id, :presence => true
  validate :validate_mask_with_configutation_organogram

  has_one :address, :as => :addressable, :dependent => :destroy
  belongs_to :configuration_organogram
  belongs_to :type_of_administractive_act

  accepts_nested_attributes_for :address

  orderize
  filterize

  def validate_mask_with_configutation_organogram
    if configuration_organogram
      MaskValidator.new({ :with => configuration_organogram.mask, :attributes => 'organogram' }).
        validate_each(self, :organogram, organogram)
    end
  end

  def to_s
    name
  end
end
