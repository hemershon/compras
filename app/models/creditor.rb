class Creditor < ActiveRecord::Base
  attr_accessible :person_id, :occupation_classification_id, :company_size_id
  attr_accessible :main_cnae_id, :municipal_public_administration, :autonomous
  attr_accessible :social_identification_number, :choose_simple
  attr_accessible :social_identification_number_date

  belongs_to :person
  belongs_to :occupation_classification
  belongs_to :company_size
  belongs_to :main_cnae, :class_name => 'Cnae'

  validates :person, :presence => true
  validates :social_identification_number_date, 
    :presence => { :if => :social_identification_number? },
    :timeliness => { :before => :today, :type => :date, :allow_blank => true }
  validates :company_size, :main_cnae, :presence => { :if => :company? }

  orderize :id
  filterize

  def to_s
    person.to_s
  end

  protected

  def company?
    person_id? && person.company?
  end
end
