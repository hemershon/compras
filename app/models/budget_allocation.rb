class BudgetAllocation < Compras::Model
  attr_accessible :descriptor_id, :budget_structure_id, :date
  attr_accessible :subfunction_id, :government_program_id, :amount, :personal
  attr_accessible :government_action_id, :foresight, :education
  attr_accessible :expense_nature_id, :capability_id, :kind
  attr_accessible :debt_type, :refinancing, :health
  attr_accessible :alienation_appeal, :function, :function_id

  attr_writer :function, :function_id

  attr_readonly :code

  attr_modal :code, :descriptor_id

  auto_increment :code, :by => :descriptor_id

  has_enumeration_for :debt_type
  has_enumeration_for :kind, :with => BudgetAllocationKind, :create_helpers => true

  belongs_to :descriptor
  belongs_to :budget_structure
  belongs_to :subfunction
  belongs_to :government_program
  belongs_to :government_action
  belongs_to :expense_nature
  belongs_to :capability

  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :pledges, :dependent => :restrict
  has_many :reserve_funds, :dependent => :restrict
  has_many :direct_purchase_budget_allocations, :dependent => :restrict
  has_many :administrative_process_budget_allocations, :dependent => :restrict

  delegate :expense_nature, :description, :to => :expense_nature, :allow_nil => true, :prefix => true
  delegate :code, :budget_structure, :to => :budget_structure, :prefix => true, :allow_nil => true

  validates :descriptor, :budget_structure, :subfunction, :date,
            :government_program, :government_action,
            :expense_nature, :capability, :function, :presence => true
  validates :amount, :presence => true, :if => :divide?
  validates :code, :uniqueness => { :scope => [:descriptor_id] }, :allow_blank => true

  orderize :code

  scope :term, lambda { |q|
    joins { budget_structure }.joins { expense_nature }.
    where { (budget_structure.full_code.like("#{q}%")  | expense_nature.description.like("#{q}%")) }
  }

  scope :budget_structure_id, lambda { |budget_structure_id|
    where { |budget_allocation|
      budget_allocation.budget_structure_id.eq(budget_structure_id)
    }
  }

  def self.filter(options)
    query = scoped
    query = query.where { budget_structure_id.eq(options[:budget_structure_id]) } if options[:budget_structure_id].present?
    query = query.where { subfunction_id.eq(options[:subfunction_id]) } if options[:subfunction_id].present?
    query = query.where { government_program_id.eq(options[:government_program_id]) } if options[:government_program_id].present?
    query = query.where { government_action_id.eq(options[:government_action_id]) } if options[:government_action_id].present?
    query = query.where { expense_nature_id.eq(options[:expense_nature_id]) } if options[:expense_nature_id].present?
    query = query.joins { subfunction }.where { subfunction.function_id.eq(options[:function_id]) } if options[:function_id].present?
    query = query.where { descriptor_id.eq(options[:descriptor_id]) } if options[:descriptor_id].present?
    query
  end

  def reserved_value
    reserve_funds.collect(&:value).sum
  end

  def real_amount
    (amount || BigDecimal(0)) - reserved_value
  end

  def to_s
    "#{budget_structure_budget_structure} - #{expense_nature_description}"
  end

  def function
    subfunction.try(:function) || @function
  end

  def function_id
    subfunction.try(:function_id) || @function_id
  end
end
