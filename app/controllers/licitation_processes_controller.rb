class LicitationProcessesController < CrudController
  def new
    object = build_resource
    object.year = Date.current.year
    object.process_date = Date.current

    super
  end

  protected

  def create_resource(object)
    InvitedBidderStatusChanger.new(object).change

    object.process = object.next_process
    object.licitation_number = object.next_licitation_number

    super
  end

  def update_resource(object, attributes)
    object.localized.assign_attributes(*attributes)

    InvitedBidderStatusChanger.new(object).change

    object.save
  end
end
