class Auction::AuctionsController < Auction::BaseController
  skip_before_filter :authenticate_user!, :only => :external_index
  skip_before_filter :authorize_resource!, :only => :external_index
  layout "auction", :only => [ :external_index ]

  def create
    create! do |success, failure|
      success.html { redirect_to collection_path }
      failure.html { render :new }

      success.js { render content_type: 'text/json' }
      failure.js { render :form_errors, content_type: 'text/json', status: :unprocessable_entity }
    end
  end
  def update
    update! do |success, failure|
      success.html { redirect_to collection_path }
      failure.html { render :edit }

      success.js { render content_type: 'text/json' }
      failure.js { render :form_errors, content_type: 'text/json', status: :unprocessable_entity }
    end
  end

  def external_index

  end

end
