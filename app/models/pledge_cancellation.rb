class PledgeCancellation < ActiveRecord::Base
  attr_accessible :pledge_id, :date, :kind, :reason, :value, :nature
  attr_accessible :pledge_parcel_id, :entity_id, :year

  has_enumeration_for :kind, :with => PledgeCancellationKind, :create_helpers => true
  has_enumeration_for :nature, :with => PledgeCancellationNature

  belongs_to :entity
  belongs_to :pledge
  belongs_to :pledge_parcel

  delegate :emission_date, :to => :pledge, :allow_nil => true
  delegate :value, :to => :pledge, :prefix => true, :allow_nil => true
  delegate :expiration_date, :balance, :to => :pledge_parcel, :allow_nil => true
  delegate :value, :to => :pledge_parcel, :prefix => true, :allow_nil => true

  validates :pledge, :date, :kind, :reason, :value, :entity, :presence => true
  validates :year, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validates :date, :timeliness => {
    :on_or_after => lambda { last.date },
    :on_or_after_message => :must_be_greater_or_equal_to_last_pledge_cancellation_date,
    :type => :date,
    :on => :create,
    :allow_blank => true,
    :if => :any_pledge_cancellation?
  }
  validate :value_validation
  validate :date_must_be_equal_or_greater_than_pledge_emission_date

  before_validation :force_value_to_total_kind

  orderize :id
  filterize

  def to_s
    "#{id}"
  end

  protected

  def date_must_be_equal_or_greater_than_pledge_emission_date
    return if emission_date.blank? || date.blank?

    if date < emission_date
      errors.add(:date, :must_be_equal_or_greater_than_pledge_emission_date)
    end
  end

  def any_pledge_cancellation?
    self.class.any?
  end

  def force_value_to_total_kind
    if pledge_parcel.present? && total?
      self.value = pledge_parcel.value
    end
  end

  def value_validation
    return if pledge_parcel.blank?

    if value > balance
      errors.add(:value, :must_not_be_greater_than_pledge_parcel_balance)
    end
  end
end
