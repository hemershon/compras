class JudgmentCommissionAdvice < ActiveRecord::Base
  attr_accessible :licitation_process_id, :licitation_commission_id, :year, :minutes_number
  attr_accessible :judgment_commission_advice_members_attributes

  belongs_to :licitation_process
  belongs_to :licitation_commission

  has_many :judgment_commission_advice_members, :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :judgment_commission_advice_members, :allow_destroy => true

  delegate :modality_humanize, :to => :licitation_process, :allow_nil => true, :prefix => true
  delegate :next_judgment_commission_advice, :to => :licitation_process, :allow_nil => true, :prefix => true
  delegate :president_name, :to => :licitation_commission, :allow_nil => true, :prefix => true

  validates :licitation_process, :licitation_commission, :year, :minutes_number, :presence => true
  validates :year, :mask => "9999"

  validate :cannot_have_duplicated_individuals_on_members

  orderize :id
  filterize

  def to_s
    "#{id}/#{year}"
  end

  def next_minutes_number
    last_minutes_number_of_self_year.succ
  end

  protected

  def last_minutes_number_of_self_year
    last_by_self_year.try(:minutes_number).to_i
  end

  def last_by_self_year
    self.class.where { |p| p.year.eq(year) }.order { id }.last
  end

  def cannot_have_duplicated_individuals_on_members
    single_individuals = []

    judgment_commission_advice_members.each do |responsible|
      if single_individuals.include?(responsible.individual_id)
        errors.add(:judgment_commission_advice_members)
        responsible.errors.add(:individual_id, :taken)
      end
      single_individuals << responsible.individual_id
    end
  end
end
