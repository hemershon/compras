# encoding: utf-8
class PurchaseProcessCreditorProposalsController < CrudController
  defaults resource_class: LicitationProcess

  before_filter :load_licitation_process, only: [:index, :new]
  before_filter :load_creditor, except: [:index]

  has_scope :licitation_process_id, allow_blank: true
  has_scope :creditor_id, allow_blank: true

  def index
    respond_to do |format|
      format.json { @creditor_proposals = apply_scopes(PurchaseProcessCreditorProposal).all }
      format.html { @creditors = @licitation_process.creditors_enabled.includes(:purchase_process_creditor_proposals) }
    end
  end

  def new
    @proposals = PurchaseProcessCreditorProposalBuilder.build_proposals(@licitation_process, @creditor)
  end

  def edit
    @proposals = resource.proposals_of_creditor(@creditor)
  end

  def update
    update! do |success, failure|
      success.html { redirect_to purchase_process_creditor_proposals_path(licitation_process_id: resource.id) }
    end
  end

  private

  def load_licitation_process
    @licitation_process = LicitationProcess.find(params[:licitation_process_id])
  end

  def load_creditor
    @creditor = Creditor.find params.delete(:creditor_id)
  end

  def interpolation_options
    { resource_name: PurchaseProcessCreditorProposal.model_name.human }
  end
end
