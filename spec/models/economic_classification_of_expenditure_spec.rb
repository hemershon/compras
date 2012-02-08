# encoding: utf-8
require 'model_helper'
require 'app/models/economic_classification_of_expenditure'

describe EconomicClassificationOfExpenditure do
  it 'should return economic_classification_of_expenditure as to_s method' do
    subject.economic_classification_of_expenditure = '3.1.90.11.01.00.00.00'
    subject.to_s.should eq '3.1.90.11.01.00.00.00'
  end

  it { should belong_to :administractive_act }
  it { should belong_to :entity }

  it { should validate_presence_of :economic_classification_of_expenditure }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :description }

  it { should allow_value('3.1.90.11.01.00.00.00').for(:economic_classification_of_expenditure) }
  it { should_not allow_value('1234').for(:economic_classification_of_expenditure) }
end
