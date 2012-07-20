# encoding: utf-8
require 'model_helper'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/reserve_fund'
require 'app/models/pledge'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/extra_credit_moviment_type'
require 'app/models/administrative_process_budget_allocation'

describe BudgetAllocation do
  describe 'default values' do
    it 'uses false as default for refinancing' do
      subject.refinancing.should be false
    end

    it 'uses false as default for health' do
      subject.health.should be false
    end

    it 'uses false as default for alienation_appeal' do
      subject.alienation_appeal.should be false
    end

    it 'uses false as default for education' do
      subject.education.should be false
    end

    it 'uses false as default for foresight' do
      subject.foresight.should be false
    end

    it 'uses false as default for personal' do
      subject.personal.should be false
    end
  end

  it 'should return "budget structure code - description" as to_s' do
    subject.description = 'Secretaria de educação'
    subject.stub(:budget_structure_code => '1')
    subject.to_s.should eq '1 - Secretaria de educação'
  end

  it { should validate_presence_of :budget_allocation_type }
  it { should validate_presence_of :budget_structure }
  it { should validate_presence_of :capability }
  it { should validate_presence_of :date }
  it { should validate_presence_of :description }
  it { should validate_presence_of :descriptor }
  it { should validate_presence_of :expense_nature }
  it { should validate_presence_of :goal }
  it { should validate_presence_of :government_action }
  it { should validate_presence_of :government_program }
  it { should validate_presence_of :subfunction }
  it { should validate_presence_of :function }

  it { should belong_to(:descriptor) }
  it { should belong_to(:budget_structure) }
  it { should belong_to(:subfunction) }
  it { should belong_to(:government_program) }
  it { should belong_to(:government_action) }
  it { should belong_to(:expense_nature) }
  it { should belong_to(:capability) }

  it { should have_many(:extra_credit_moviment_types).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:reserve_funds).dependent(:restrict) }
  it { should have_many(:direct_purchase_budget_allocations).dependent(:restrict) }
  it { should have_many(:administrative_process_budget_allocations).dependent(:restrict) }

  it { should auto_increment(:code).by([:descriptor_id]).on(:before_create) }

  it 'should validate presence of amount if kind is average' do
    subject.stub(:divide?).and_return(true)
    subject.should validate_presence_of :amount
  end

  it 'should not validate presence of amount if kind is average' do
    subject.stub(:divide?).and_return(false)
    subject.should_not validate_presence_of :amount
  end

  it 'should calculate reserved value' do
    subject.reserved_value.should eq 0

    fund1 = double(:value => 3200)
    fund2 = double(:value => 2500)
    subject.stub(:reserve_funds).and_return([fund1, fund2])

    subject.reserved_value.should eq 5700
  end

  context '#real_amount' do
    it 'should calculate the right real value when the amount is not nil' do
      subject.stub(:amount => 400.0, :reserved_value => 200.0)
      subject.real_amount.should eq(200.0)
    end

    it 'should calculate the right real value when the amount is nil' do
      subject.stub(:amount => nil, :reserved_value => 200.0)
      subject.real_amount.should eq(-200.0)
    end
  end

  context '#function' do
    let :subfunction do
      double(:subfunction, :id => 1, :function => 'Subfunction-Function', :function_id => 2)
    end

    it "should return funtion value if has not a subfunction" do
      subject.function = 'Function'

      subject.function.should eq 'Function'
    end

    it "should return subfunction.function value if has a subfunction" do
      subject.stub(:subfunction => subfunction)

      subject.function.should eq 'Subfunction-Function'
    end

    it "should return funtion_id value if has not a subfunction" do
      subject.function_id = 1

      subject.function_id.should eq 1
    end

    it "should return subfunction.function_id value if has a subfunction" do
      subject.stub(:subfunction => subfunction)

      subject.function_id.should eq 2
    end
  end
end
