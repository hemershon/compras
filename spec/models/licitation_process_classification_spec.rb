# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_classification'

describe LicitationProcessClassification do
  it { should belong_to :licitation_process_bidder }
  it { should belong_to :classifiable }

  context '#disqualified' do
    it 'should be false' do
      subject.classification = 1

      expect(subject.disqualified?).to be false
    end

    it 'should be true' do
      subject.classification = -1

      expect(subject.disqualified?).to be true
    end
  end

  context 'benefited value' do
    it 'should return total value' do
      subject.stub(:benefited => false, :total_value => 100)

      expect(subject.benefited_value(10)).to eq 100
    end

    it 'should return total value discounted percentage' do
      subject.stub(:benefited => true, :total_value => 100)

      expect(subject.benefited_value(10)).to eq 90
    end
  end
end