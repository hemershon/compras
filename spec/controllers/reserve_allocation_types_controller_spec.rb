require 'spec_helper'

describe ReserveAllocationTypesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses manual as default value for source' do
    post :create

    assigns(:reserve_allocation_type).source.should eq Source::MANUAL
  end
end
