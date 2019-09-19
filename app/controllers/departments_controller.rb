class DepartmentsController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :limit
  has_scope :without_children, :type => :boolean

  before_filter :block_when_not_editable, :only => [:update, :destroy]

  def new
    object = build_resource

    super
  end

  private

  def block_when_not_editable
    return if resource.editable?

    raise Exceptions::Unauthorized
  end

end
