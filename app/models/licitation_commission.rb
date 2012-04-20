class LicitationCommission < ActiveRecord::Base
  attr_accessible :commission_type, :nomination_date, :expiration_date, :exoneration_date
  attr_accessible :description, :regulatory_act_id, :licitation_commission_responsibles_attributes
  attr_accessible :licitation_commission_members_attributes

  has_enumeration_for :commission_type

  belongs_to :regulatory_act

  has_many :licitation_commission_responsibles, :dependent => :destroy, :order => :id
  has_many :licitation_commission_members, :dependent => :destroy, :order => :id
  has_many :accreditations, :dependent => :restrict

  accepts_nested_attributes_for :licitation_commission_responsibles, :allow_destroy => true
  accepts_nested_attributes_for :licitation_commission_members, :allow_destroy => true

  delegate :publication_date, :to => :regulatory_act, :allow_nil => true, :prefix => true

  validates :commission_type, :nomination_date, :expiration_date, :exoneration_date, :regulatory_act, :presence => true
  validates :expiration_date, :exoneration_date, :timeliness => { :on_or_after => :nomination_date, :type => :date }, :allow_blank => true

  validate :cannot_have_duplicated_individuals_on_responsibles
  validate :cannot_have_duplicated_individuals_on_members
  validate :must_have_one_member_with_role_president

  orderize :id
  filterize

  def to_s
    id.to_s
  end

  def president
    licitation_commission_members.first(:conditions => "role = '#{LicitationCommissionMemberRole::PRESIDENT}'")
  end

  def president_name
    commission_president = president
    commission_president.individual.to_s if commission_president
  end

  protected

  def cannot_have_duplicated_individuals_on_responsibles
    single_individuals = []

    licitation_commission_responsibles.each do |responsible|
      if single_individuals.include?(responsible.individual_id)
        errors.add(:licitation_commission_responsibles)
        responsible.errors.add(:individual_id, :taken)
      end
      single_individuals << responsible.individual_id
    end
  end

  def cannot_have_duplicated_individuals_on_members
    single_individuals = []

    licitation_commission_members.each do |responsible|
      if single_individuals.include?(responsible.individual_id)
        errors.add(:licitation_commission_members)
        responsible.errors.add(:individual_id, :taken)
      end
      single_individuals << responsible.individual_id
    end
  end

  def must_have_one_member_with_role_president
    presidents_count = 0

    licitation_commission_members.each do |member|
      presidents_count += 1 if member.president?
    end

    if presidents_count != 1
      errors.add(:licitation_commission_members, :must_have_one_president)
    end
  end
end
