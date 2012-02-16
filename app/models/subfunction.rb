class Subfunction < ActiveRecord::Base
  attr_accessible :code, :description, :function_id

  belongs_to :function

  orderize :code
  filterize

  validates :code, :presence => true, :uniqueness => true
  validates :description, :function_id, :presence => true

  def to_s
    "#{code} - #{description}"
  end
end
