# encoding: utf-8
require 'model_helper'
require 'app/models/macro_objective'

describe MacroObjective do
  it { should validate_presence_of :specification }

  it "should return specification as to_s" do
    subject.specification = 'Desenvolvimento econômico'

    subject.to_s.should eq 'Desenvolvimento econômico'
  end
end
