class DirectPurchasesController < CrudController
  actions :all, :except => :destroy

  has_scope :authorized, :type => :boolean

  def new
    object = build_resource
    object.employee = current_user.authenticable
    object.status = DirectPurchaseStatus::UNAUTHORIZED
    object.date = Date.current

    super
  end

  def create
    object = build_resource
    object.status = DirectPurchaseStatus::UNAUTHORIZED

    super
  end

  def update
    supply_authorization = SupplyAuthorizationGenerator.new(resource).generate!
    redirect_to supply_authorization
  end

  protected

  def create_resource(object)
    object.direct_purchase = object.next_purchase

    super
  end

end
