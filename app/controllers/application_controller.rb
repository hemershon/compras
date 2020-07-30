class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_user

  around_filter :handle_customer
  before_filter :handle_action_mailer
  before_filter :authenticate_user!
  before_filter :set_customer_to_api_resources

  rescue_from CanCan::Unauthorized, :with => :unauthorized
  rescue_from Exceptions::Unauthorized, :with => :unauthorized

  helper_method :current_prefecture, :current_customer

  def current_prefecture
    Prefecture.last
  end

  def current_customer
    @current_customer ||= CustomerFinder.current(request)
  end

  protected

  def layout_by_user
    if current_user && current_user.creditor?
      'creditor'
    elsif current_user && current_user.electronic_auction?
      'electronic_auction'
    else
      'application'
    end
  end

  def handle_customer(&block)
    customer = current_customer
    customer.using_connection(&block)
    Uploader.set_current_domain(customer.domain)
  end

  def handle_action_mailer
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def unauthorized
    if request.xhr?
      render :nothing => true, :status => :unauthorized
    else
      render :file => Rails.root.join('public/401.html'), :layout => nil, :status => 401
    end
  end

  def user_already_logged_in?
    current_user && !(session[:login_token] == current_user.login_token)
  end

  def set_customer_to_api_resources
    if Rails.env.test?
      customer = OpenStruct.new(:domain => 'compras.dev', :secret_token => current_customer.secret_token)
      UnicoAPI::Consumer.set_customer customer
    else
      UnicoAPI::Consumer.set_customer current_customer
    end
  end
end
