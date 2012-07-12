class ExpenseNature < Compras::Model
  attr_accessible :descriptor_id, :regulatory_act_id, :expense_split
  attr_accessible :expense_nature, :kind, :expense_group_id
  attr_accessible :description, :docket, :expense_category_id
  attr_accessible :expense_modality_id, :expense_element_id

  has_enumeration_for :kind, :with => ExpenseNatureKind, :create_helpers => true

  belongs_to :descriptor
  belongs_to :regulatory_act
  belongs_to :expense_category
  belongs_to :expense_group
  belongs_to :expense_modality
  belongs_to :expense_element

  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :materials, :dependent => :restrict
  has_many :budget_allocations, :dependent => :restrict
  has_many :pledges, :dependent => :restrict

  delegate :code, :to => :expense_category, :prefix => true, :allow_nil => true
  delegate :code, :to => :expense_group, :prefix => true, :allow_nil => true
  delegate :code, :to => :expense_modality, :prefix => true, :allow_nil => true
  delegate :code, :to => :expense_element, :prefix => true, :allow_nil => true

  validates :expense_nature, :kind, :description, :expense_group, :presence => true
  validates :expense_modality, :expense_element, :expense_split, :presence => true
  validates :expense_split, :mask => '99', :allow_blank => true
  validates :descriptor, :regulatory_act, :expense_category, :presence => true

  orderize :description

  def self.filter(params)
    relation = scoped
    relation = relation.where { expense_nature.eq(params[:expense_nature]) } if params[:expense_nature].present?
    relation = relation.where { description.eq(params[:description]) } if params[:description].present?
    relation = relation.where { descriptor_id.eq(params[:descriptor_id]) } if params[:descriptor_id].present?
    relation = relation.where { regulatory_act_id.eq(params[:regulatory_act_id]) } if params[:regulatory_act_id].present?
    relation = relation.where { kind.eq(params[:kind]) } if params[:kind].present?

    if params[:expense_category_id].present?
      category_id = value_or_nil(params[:expense_category_id])

      relation = relation.where { expense_category_id.eq(category_id) }
    end

    if params[:expense_group_id].present?
      group_id = value_or_nil(params[:expense_group_id])

      relation = relation.where { expense_group_id.eq(group_id) }
    end

    if params[:expense_modality_id].present?
      modality_id = value_or_nil(params[:expense_modality_id])

      relation = relation.where { expense_modality_id.eq(modality_id) }
    end

    if params[:expense_element_id].present?
      element_id = value_or_nil(params[:expense_element_id])

      relation = relation.where { expense_element_id.eq(element_id) }
    end

    relation
  end

  scope :expense_nature_not_eq, lambda { |code| where { expense_nature.not_eq(code) } }

  def to_s
    "#{expense_nature} - #{description}"
  end

  protected

  def self.value_or_nil(param)
    param == '0' ? nil : param
  end
end
