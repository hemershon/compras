class Employee < ActiveRecord::Base
  attr_accessible :person_id, :registration

  belongs_to :person
  has_one :user
  has_many :purchase_solicitations, :as => :responsible
  has_many :organogram_responsibles, :as => :responsible

  validates :person_id, :registration, :uniqueness => true
  validates :person, :registration, :presence => true

  filterize
  scope :ordered, joins { person }.order(:person => :name)

  delegate :to_s, :to => :person
  delegate :name, :to => :person
end
