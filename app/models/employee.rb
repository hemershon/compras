class Employee < ActiveRecord::Base
  attr_accessible :person_id, :registration

  belongs_to :person

  validates :person_id, :registration, :presence => true, :uniqueness => true

  filterize
  scope :ordered, joins { person }.order(:person => :name)

  delegate :to_s, :to => :person
  delegate :name, :to => :person
end
