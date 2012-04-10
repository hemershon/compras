class LicitationCommission < ActiveRecord::Base
  attr_accessible :commission_type, :nomination_date, :expiration_date, :exoneration_date
  attr_accessible :description, :regulatory_act_id, :licitation_commission_responsibles_attributes

  attr_modal :commission_type, :nomination_date, :expiration_date, :exoneration_date

  has_enumeration_for :commission_type

  belongs_to :regulatory_act

  has_many :licitation_commission_responsibles, :dependent => :destroy

  accepts_nested_attributes_for :licitation_commission_responsibles, :allow_destroy => true

  delegate :publication_date, :to => :regulatory_act, :allow_nil => true, :prefix => true

  validates :commission_type, :nomination_date, :expiration_date, :exoneration_date, :regulatory_act, :presence => true
  validates :expiration_date, :exoneration_date, :timeliness => { :on_or_after => :nomination_date, :type => :date }, :allow_blank => true

  validate :cannot_have_duplicated_individuals

  orderize :id
  filterize

  def to_s
    id.to_s
  end

  protected

  def cannot_have_duplicated_individuals
    single_individuals = []

    licitation_commission_responsibles.each do |responsible|
      if single_individuals.include?(responsible.individual_id)
        errors.add(:licitation_commission_responsibles)
        responsible.errors.add(:individual_id, :taken)
      end
      single_individuals << responsible.individual_id
    end
  end
end
