class AccountPlanConfiguration < Compras::Model
  attr_accessible :description, :mask, :year, :state_id,
                  :account_plan_levels, :account_plan_levels_attributes

  attr_accessor :mask

  attr_modal :year, :state_id, :description

  belongs_to :state

  has_many :account_plan_levels, :dependent => :destroy

  accepts_nested_attributes_for :account_plan_levels, :allow_destroy => true

  validates :description, :year, :state, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validates :account_plan_levels, :no_duplication => :level
  validate :separator_for_levels

  orderize :id
  filterize

  def to_s
    description
  end

  def ordered_account_plan_levels
    account_plan_levels.sort_by(&:level)
  end

  def mask(mask_generator = MaskConfigurationParser)
    mask_generator.from_levels(ordered_account_plan_levels)
  end

  protected

  def separator_for_levels
    ordered_account_plan_levels.each_with_index do |account_plan_level, idx|
      if account_plan_level.separator.blank? && idx.succ < account_plan_levels.size
        account_plan_level.errors.add(:separator, :blank)
      end
    end
  end
end
