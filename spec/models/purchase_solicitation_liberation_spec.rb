# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_liberation'

describe PurchaseSolicitationLiberation do
  it { should belong_to :responsible }
  it { should belong_to :purchase_solicitation }

  it { should validate_presence_of :date }
  it { should validate_presence_of :justification }
  it { should validate_presence_of :responsible }

  it 'should validate #to_s' do
    subject.stub(:sequence => 1)
    subject.to_s.should eq '1'
  end
end
