# encoding: utf-8
require 'model_helper'
require 'app/models/materials_class'
require 'app/models/material'

describe MaterialsClass do
  it { should have_many(:materials).dependent(:restrict) }

  it { should validate_presence_of :class_number }
  it { should validate_presence_of :description }
  it { should validate_presence_of :mask }

  it 'should return class_number and description as to_s method' do
    subject.class_number = '01'
    subject.description = 'Hortifrutigranjeiros'

    expect(subject.to_s).to eq '01 - Hortifrutigranjeiros'
  end
end
