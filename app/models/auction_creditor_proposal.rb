class AuctionCreditorProposal < Compras::Model
  attr_accessible :auction_id,:term,:impediment,:proposal_independent,:art_5,:art_93_pcd,:art_529_clt, :user_id,
                  :proposal_doc,:proposal_qualification_doc, :auction_creditor_proposal_items_attributes,
                  :proposal_send_date, :qualification_send_date

  mount_uploader :proposal_doc, UnicoUploader
  mount_uploader :proposal_qualification_doc, UnicoUploader

  belongs_to :auction
  belongs_to :user

  has_many :auction_creditor_proposal_items, dependent: :destroy

  accepts_nested_attributes_for :auction_creditor_proposal_items, :allow_destroy => true

  before_save :set_proposal_send_date
  before_save :set_qualification_send_date

  private

  def set_proposal_send_date
    if self.proposal_doc_changed?
      self.proposal_send_date = Date.today
    end
  end

  def set_qualification_send_date
    if self.proposal_qualification_doc_changed?
      self.qualification_send_date = Date.today
    end
  end
end
