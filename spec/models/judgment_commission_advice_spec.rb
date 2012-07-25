# encoding: utf-8
require 'model_helper'
require 'app/models/judgment_commission_advice'
require 'app/models/judgment_commission_advice_member'
require 'app/models/unico/individual'
require 'app/models/individual'

describe JudgmentCommissionAdvice do
  it { should belong_to :licitation_process }
  it { should belong_to :licitation_commission }

  it { should have_many(:judgment_commission_advice_members).dependent(:destroy).order(:id) }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :licitation_commission }
  it { should validate_presence_of :year }
  it { should validate_presence_of :judgment_start_date }
  it { should validate_presence_of :judgment_start_time }
  it { should validate_presence_of :judgment_end_date }
  it { should validate_presence_of :judgment_end_time }
  it { should validate_presence_of :companies_minutes }
  it { should validate_presence_of :companies_documentation_minutes }
  it { should validate_presence_of :justification_minutes }
  it { should validate_presence_of :judgment_minutes }
  it { should validate_duplication_of(:individual_id).on(:judgment_commission_advice_members) }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it 'should return id/year as to_s method' do
    subject.id = 1
    subject.year = 2012

    subject.to_s.should eq '1/2012'
  end

  context "inherited and not inherited members" do
    let(:member1) do
      double('member 1', :inherited? => true)
    end

    let(:member2) do
      double('member 2', :inherited? => false)
    end

    let(:member3) do
      double('member 3', :inherited? => true)
    end

    it "it should return the inherited members" do
      subject.stub(:judgment_commission_advice_members).and_return([member1, member2, member3])

      subject.inherited_members.should eq [member1, member3]

      subject.not_inherited_members.should eq [member2]
    end

    it "should not have judgment end date/time before judgment start date/time" do
      subject.judgment_start_date = Date.new(2012, 3, 10)
      subject.judgment_start_time = "10:00"

      # same time should be valid
      subject.judgment_end_date = Date.new(2012, 3, 10)
      subject.judgment_end_time = "10:00"

      subject.valid?

      subject.errors.messages[:judgment_start_date].should be_nil

      # end after start should be valid
      subject.judgment_end_date = Date.new(2012, 3, 11)
      subject.judgment_end_time = "9:00"

      subject.valid?

      subject.errors.messages[:judgment_start_date].should be_nil

      # end before start should be invalid
      subject.judgment_end_date = Date.new(2012, 3, 10)
      subject.judgment_end_time = "9:59"

      subject.valid?

      subject.errors.messages[:judgment_end_date].should include "data do fim do julgamento não pode ser anterior a data do início do julgamento"
    end
  end
end
