class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_user

  around_filter :handle_customer
  before_filter :handle_action_mailer
  before_filter :authenticate_user!

  rescue_from CanCan::Unauthorized, :with => :unauthorized
  rescue_from Exceptions::Unauthorized, :with => :unauthorized

  helper_method :current_prefecture, :current_customer

  def current_prefecture
    Prefecture.last
  end

  def current_customer
    @current_customer ||= CustomerFinder.current(request.headers['X-Customer'])
  end

  def render_to_pdf(partial_name, options = {})
    locals = options.fetch(:locals, {})

    pdf_instance = PDFKit.new render_to_string(:partial => partial_name, :locals => locals)

    if Rails.env.production? || Rails.env.staging? || Rails.env.training?
      pdf_instance.stylesheets += options.fetch(:stylesheets, ["#{root_url_for_pdf}/compras/assets/report.css"])
    end

    pdf_instance.to_pdf
  end

  protected

  def root_url_for_pdf
    "#{request.protocol}#{current_customer.domain}"
  end

  def layout_by_user
    if current_user && current_user.creditor?
      'creditor'
    else
      'application'
    end
  end

  def authorize_resource!
    authorize! action_name, controller_name
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
end
