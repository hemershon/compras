class LicitationProcess < Compras::Model
  attr_accessible :payment_method_id, :type_of_purchase,
                  :year, :process_date,:readjustment_index_id, :caution_value,
                  :envelope_delivery_date,
                  :envelope_delivery_time, :proposal_envelope_opening_date,
                  :proposal_envelope_opening_time, :document_type_ids,
                  :period, :period_unit, :expiration, :expiration_unit,
                  :judgment_form_id, :execution_type,
                  :price_registration, :status,:object_type, :date,
                  :protocol, :modality, :description,
                  :purchase_process_budget_allocations_attributes,
                  :contract_guarantees, :extension_clause, :index_update_rate_id,
                  :type_of_removal, :eletronic_trading, :notice_availability_date,
                  :contact_id, :stage_of_bids_date, :stage_of_bids_time,
                  :items_attributes, :minimum_bid_to_disposal, :concession_period,
                  :concession_period_unit, :goal, :licensor_rights_and_liabilities,
                  :licensee_rights_and_liabilities, :authorization_envelope_opening_date,
                  :authorization_envelope_opening_time, :closing_of_accreditation_date,
                  :closing_of_accreditation_time, :purchase_solicitation_ids,
                  :budget_allocations_total_value, :total_value_of_items,
                  :creditor_proposals_attributes, :tied_creditor_proposals_attributes,
                  :execution_unit_responsible_id, :process_responsibles_attributes,
                  :justification, :justification_and_legal

  auto_increment :process, :by => :year
  auto_increment :modality_number, :by => [:year, :modality, :type_of_removal]

  attr_readonly :process, :year, :modality_number

  attr_modal :process, :year, :process_date

  has_enumeration_for :concession_period_unit, :with => PeriodUnit
  has_enumeration_for :contract_guarantees
  has_enumeration_for :execution_type, :create_helpers => true
  has_enumeration_for :expiration_unit, :with => PeriodUnit
  has_enumeration_for :modality, :create_helpers => true, :create_scopes => true
  has_enumeration_for :object_type, :with => PurchaseProcessObjectType, :create_helpers => true
  has_enumeration_for :period_unit, :with => PeriodUnit, create_helpers: { prefix: true }
  has_enumeration_for :status, :with => PurchaseProcessStatus, :create_helpers => true
  has_enumeration_for :type_of_purchase, :with => PurchaseProcessTypeOfPurchase,
    :create_helpers => true, create_scopes: true
  has_enumeration_for :type_of_removal, create_helpers: { prefix: true }

  belongs_to :contact, :class_name => 'Employee'
  belongs_to :judgment_form
  belongs_to :payment_method
  belongs_to :readjustment_index, :class_name => 'Indexer'
  belongs_to :index_update_rate, :class_name => 'Indexer'
  belongs_to :execution_unit_responsible, class_name: 'BudgetStructure'

  has_and_belongs_to_many :document_types, :join_table => :compras_document_types_compras_licitation_processes
  has_and_belongs_to_many :purchase_solicitations, :join_table => :compras_licitation_processes_purchase_solicitations,
                          :before_add => :update_purchase_solicitation_to_purchase_process,
                          :before_remove => :update_purchase_solicitation_to_liberated

  has_many :publications, class_name: 'LicitationProcessPublication', dependent: :destroy, order: :id
  has_many :bidders, :dependent => :destroy, :order => :id
  has_many :licitation_process_impugnments, :dependent => :restrict, :order => :id
  has_many :licitation_process_appeals, :dependent => :restrict
  has_many :pledges, :dependent => :restrict
  has_many :licitation_notices, :dependent => :destroy
  has_many :reserve_funds, :dependent => :restrict
  has_many :licitation_process_ratifications, :dependent => :restrict, :order => :id
  has_many :ratifications_items, through: :licitation_process_ratifications, source: :licitation_process_ratification_items, order: :id
  has_many :classifications, :through => :bidders, :class_name => 'LicitationProcessClassification',
           :source => :licitation_process_classifications
  has_many :purchase_process_budget_allocations, :dependent => :destroy, :order => :id
  has_many :budget_allocations, :through => :purchase_process_budget_allocations
  has_many :budget_allocation_capabilities, through: :budget_allocations
  has_many :items, :class_name => 'PurchaseProcessItem', :dependent => :restrict,
           :order => :id, :inverse_of => :licitation_process
  has_many :materials, :through => :items
  has_many :legal_analysis_appraisals, :dependent => :restrict
  has_many :license_creditors, :through => :bidders, :dependent => :restrict, :source => :creditor, order: :id
  has_many :accreditation_creditors, :through => :purchase_process_accreditation, :source => :creditors, order: :id
  has_many :creditor_proposals, class_name: 'PurchaseProcessCreditorProposal', order: :id
  has_many :realigment_prices, through: :creditor_proposals
  has_many :tied_creditor_proposals, class_name: 'PurchaseProcessCreditorProposal',
           conditions: { tied: true }, order: 'ranking, creditor_id, purchase_process_item_id, lot'
  has_many :items_creditors, through: :items, source: :creditor, order: :id
  has_many :creditor_disqualifications, class_name: 'PurchaseProcessCreditorDisqualification', dependent: :restrict
  has_many :process_responsibles, :dependent => :restrict
  has_many :trading_items, through: :trading, source: :items, order: :id
  has_many :trading_item_bids, through: :trading_items, source: :bids, order: :id
  has_many :trading_item_negotiations, through: :trading_items, source: :negotiation, order: :id

  has_one :judgment_commission_advice, :dependent => :restrict
  has_one :purchase_process_accreditation, :dependent => :restrict
  has_one :trading, class_name: 'PurchaseProcessTrading', :dependent => :restrict,
    foreign_key: :purchase_process_id

  accepts_nested_attributes_for :purchase_process_budget_allocations, :items, :creditor_proposals,
                                :process_responsibles, :tied_creditor_proposals, allow_destroy: true

  delegate :allow_negotiation?, to: :trading, allow_nil: true, prefix: true
  delegate :issuance_date, to: :judgment_commission_advice, allow_nil: true, prefix: true
  delegate :licitation_kind, :kind, :best_technique?, :technical_and_price?,
           :best_auction_or_offer?, :item?, :lot?, :global?, :higher_discount_on_table?,
           :lowest_price?, :higher_discount_on_lot?, :higher_discount_on_item?,
           :to => :judgment_form, :allow_nil => true, :prefix => true

  validates :process_date, :period, :contract_guarantees, :type_of_purchase,
            :period_unit, :payment_method,
            :year, :execution_type, :object_type, :description, :notice_availability_date,
            :presence => true
  validates :envelope_delivery_date, :envelope_delivery_time, :expiration, :expiration_unit,
            :modality, :judgment_form_id, :presence => true, :if => :licitation?
  validates :goal, :licensor_rights_and_liabilities, :licensee_rights_and_liabilities,
            :presence => true, :if => :concessions_or_permits?
  validates :type_of_removal, :justification, :justification_and_legal, :presence => true, :if => :direct_purchase?
  validates :tied_creditor_proposals, no_duplication: {
    with: :ranking,
    allow_nil: true,
    scope: [:licitation_process_id, :purchase_process_item_id, :lot],
    if_condition: lambda { |creditor_proposal| creditor_proposal.ranking > 0 }
  }
  validates :items, no_duplication: {
    with: :material_id,
    scope: [:creditor_id],
    message: :material_cannot_be_duplicated_by_creditor
  }
  validate :validate_bidders_before_edital_publication
  validate :validate_updates, :unless => :updatable?
  validate :validate_proposal_envelope_opening_date, :on => :update, :if => :licitation?
  validate :validate_the_year_to_processe_date_are_the_same, :on => :update

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :year, :mask => "9999"
    allowing_blank.validates :envelope_delivery_date,
      :timeliness => {
        :on_or_after => :today,
        :on_or_after_message => :should_be_on_or_after_today,
        :type => :date,
        :on => :create,
        :unless => :allow_insert_past_processes?
      }
    allowing_blank.validates :proposal_envelope_opening_date,
      timeliness: {
        on_or_after: :proposal_envelope_opening_date_limit,
        type: :date,
        on: :update,
        if: :licitation?
      }
    allowing_blank.validates :proposal_envelope_opening_date,
      :timeliness => {
        :on_or_after => :envelope_delivery_date,
        :on_or_after_message => :should_be_on_or_after_envelope_delivery_date,
        :type => :date,
        :on => :create
      }
    allowing_blank.validates :envelope_delivery_time, :proposal_envelope_opening_time,
      :timeliness => {
        :type => :time,
        :on => :update
      }
    allowing_blank.validates :stage_of_bids_time,
      :timeliness => {
        :type => :time
      }
  end

  before_update :assign_bidders_documents
  before_save :calculate_total_value_of_items, :calculate_budget_allocations_total_value

  orderize "id DESC"
  filterize

  scope :with_price_registrations, where { price_registration.eq true }

  scope :without_trading, lambda { |except_id|
    joins { trading.outer }.
    where { |licitation| licitation.trading.id.eq(nil) | licitation.id.eq(except_id) }
  }

  scope :published_edital, lambda {
    joins { publications }.where {
      publications.publication_of.eq PublicationOf::EDITAL
    }
  }

  scope :by_ratification_month_and_year, lambda { |month, year|
    joins { licitation_process_ratifications }.
      where(%{
        extract(month from compras_licitation_process_ratifications.ratification_date) = ? AND
        extract(year from compras_licitation_process_ratifications.ratification_date) = ?},
        month, year)
  }

  scope :by_ratification_and_year, lambda { |year|
    joins { licitation_process_ratifications }.
    where(%{
      extract(year from compras_licitation_process_ratifications.ratification_date) = ?}, year)
  }

  scope :not_removal_by_limit, -> do
    where { type_of_removal.not_eq TypeOfRemoval::REMOVAL_BY_LIMIT }
  end

  def to_s
    "#{process}/#{year} - #{modality_humanize || type_of_removal_humanize} #{modality_number}"
  end

  def modality_or_type_of_removal
    "#{modality_number} - #{modality_humanize || type_of_removal_humanize}"
  end

  def creditors
    if direct_purchase?
      items_creditors
    elsif trading?
      accreditation_creditors
    else
      license_creditors
    end
  end

  def update_status(status)
    update_column :status, status
  end

  def envelope_opening?
    return unless proposal_envelope_opening_date
    proposal_envelope_opening_date == Date.current
  end

  def updatable?
    new_record? || ((licitation_process_ratifications.empty? || publications.empty?) && publications.current_updatable?)
  end

  def all_licitation_process_classifications
    classifications.for_active_bidders.order(:bidder_id, :classification)
  end

  def destroy_all_licitation_process_classifications
    bidders.each(&:destroy_all_classifications)
  end

  def has_bidders_and_is_available_for_classification
    !bidders.empty? && available_for_licitation_process_classification?
  end

  def winning_bid
    all_licitation_process_classifications.detect { |classification| classification.situation == SituationOfProposal::WON}
  end

  def edital_published?
    published_editals.any?
  end

  def ratification?
    licitation_process_ratifications.any?
  end

  def has_trading?
    trading.present?
  end

  def last_publication_date
    return unless current_publication

    current_publication.publication_date
  end

  def current_publication
    return if publications.empty?

    publications.current
  end

  def process_date_year
    process_date && process_date.year
  end

  def proposals_of_creditor(creditor)
    creditor_proposals.creditor_id(creditor.id).order(:id)
  end

  def proposals_total_price(creditor)
    proposals_of_creditor(creditor).sum(&:total_price)
  end

  def allow_trading_auto_creation?
    persisted? && trading? && !has_trading?
  end

  def each_item_lot
    items.map(&:lot).uniq.each do |lot|
      yield lot
    end
  end

  def all_proposals_given?
    return false if creditor_proposals.empty?

    case judgment_form_kind
    when JudgmentFormKind::ITEM
      creditor_proposals.count == creditors.count * items.count
    when JudgmentFormKind::LOT
      creditor_proposals.count == creditors.count * items.lots.count
    else
      creditor_proposals.count == creditors.count
    end
  end

  def concessions_or_permits?
    return unless object_type

    concessions? || permits?
  end

  def published_editals
    publications.edital
  end

  protected

  def available_for_licitation_process_classification?
    Modality.available_for_licitation_process_classification.include?(modality)
  end

  def assign_bidders_documents
    bidders.each do |bidder|
      bidder.assign_document_types
      bidder.save!
    end
  end

  def calculate_total_value_of_items
    return unless items

    self.total_value_of_items = items.reject(&:marked_for_destruction?).sum(&:estimated_total_price)
  end

  def calculate_budget_allocations_total_value
    return unless purchase_process_budget_allocations.any?

    self.budget_allocations_total_value = purchase_process_budget_allocations.reject(&:marked_for_destruction?).sum(&:value)
  end

  def validate_the_year_to_processe_date_are_the_same
    errors.add(:process_date, :cannot_change_the_year_from_the_date_of_dispatch) unless process_date_year == year
  end

  def validate_bidders_before_edital_publication
    if bidders.any? && !edital_published? && licitation?
      errors.add(:base, :inclusion_of_bidders_before_edital_publication)
    end
  end

  def validate_proposal_envelope_opening_date
    return unless proposal_envelope_opening_date

    unless last_publication_date
      errors.add :proposal_envelope_opening_date, :absence
      return false
    end
  end

  def proposal_envelope_opening_date_limit
    PurchaseProcessProposalEnvelopeOpeningDateCalculator.calculate(self)
  end

  def validate_updates
    if changed_attributes.any?
      errors.add(:base, :cannot_be_edited)
    end
  end

  def first_ratification
    licitation_process_ratifications.first
  end

  def current_prefecture
    Prefecture.last
  end

  def allow_insert_past_processes?
    return unless current_prefecture

    current_prefecture.allow_insert_past_processes
  end

  def material_ids_or_zero
    return 0 if material_ids.size == 0

    material_ids.join(',')
  end

  def update_purchase_solicitation_to_purchase_process(purchase_solicitation)
    purchase_solicitations.each do |purchase_solicitation|
      purchase_solicitation.buy! if valid?
    end
  end

  def update_purchase_solicitation_to_liberated(purchase_solicitation)
    purchase_solicitation.liberate! if valid?
  end
end
