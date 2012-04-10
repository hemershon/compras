require 'model_helper'
require 'app/models/expense_modality'

describe ExpenseModality do
  it 'should return code as to_s' do
    subject.code = 1
    subject.to_s.should eq '1'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
end
