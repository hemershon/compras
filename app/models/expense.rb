class Expense < Compras::Model
  belongs_to :unity, :class_name => "Organ"
  belongs_to :organ
  belongs_to :purchasing_unit
  belongs_to :expense_function
  belongs_to :expense_sub_function
  belongs_to :program
  belongs_to :project_activity
  belongs_to :nature_expense
  belongs_to :resource_source

  attr_accessible :destine_type, :destiny, :organ_id, :purchasing_unit_id,
                  :expense_function_id, :expense_sub_function_id, :program_id,
                  :project_activity_id, :nature_expense_id, :resource_source_id,
                  :unity_id, :year

  has_enumeration_for :destine_type, :with => ExpenseDestineType

  validate :organ, :unity, presence: true
  validates :year, :mask => '9999',
            numericality: {
                only_integer: true,
                greater_than_or_equal_to: 1990,
                less_than_or_equal_to: Date.today.year + 5
            }

  before_save :set_destine_type

  orderize "id DESC"
  filterize

  def to_s
    "#{organ} - #{unity}"
  end

  def set_destine_type
    destiny = self.destiny
    unless destiny.nil?
      if destiny == 0
        self.destine_type = 'special_operation'
      elsif destiny % 2 == 0
        self.destine_type = 'activity'
      elsif destiny % 2 != 0
        self.destine_type = 'project'
      end
    end
  end

end