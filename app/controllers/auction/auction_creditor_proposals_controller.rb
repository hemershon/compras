class Auction::AuctionCreditorProposalsController < Auction::BaseController
  def index
    redirect_to auction_auctions_path
  end

  def new
    object = build_resource
    object.auction_id = params[:auction_id]

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to edit_resource_path }
      failure.html { render :new }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to edit_resource_path }
      failure.html { render :new }
    end
  end

  def auctioneer_view
    @auction = Auction.find(params[:auction_id])
  end

  def show
    render layout: "document"
  end

  protected

  def create_resource(object)
    object.creditor = current_user.authenticable

    super
  end
end
