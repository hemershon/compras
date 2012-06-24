require 'model_helper'
require 'app/uploaders/document_uploader'
require 'app/models/entity'
require 'app/models/budget_structure_configuration'
require 'app/models/contract'
require 'app/models/descriptor'

describe Entity do
  it 'should return the name as to_s method' do
    subject.name = 'Denatran'
    subject.to_s.should eq 'Denatran'
  end

  it { should have_many(:budget_structure_configurations).dependent(:restrict) }
  it { should have_many(:contracts).dependent(:restrict) }
  it { should have_many(:descriptors).dependent(:restrict) }

  it { should validate_presence_of :name }
end
