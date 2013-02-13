require 'model_helper'
require 'app/models/licitation_notice'

describe LicitationNotice do
  it { should belong_to :licitation_process }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :date }
  it { should validate_presence_of :number }

  it { should delegate(:administrative_process_modality_humanize).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:licitation_number).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process_date).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:year).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:administrative_process_description).to(:licitation_process).allowing_nil(true).prefix(true) }

  it 'should return id as to_s method' do
    subject.id = '1'

    expect(subject.to_s).to eq '1'
  end

  context 'next_number' do
    it 'should return 1 as first licitation notice' do
      subject.stub(:last_number).and_return(0)
      expect(subject.next_number).to eq 1
    end

    it 'should return 2 as secondary licitation notice' do
      subject.stub(:last_number).and_return(1)
      expect(subject.next_number).to eq 2
    end
  end
end
