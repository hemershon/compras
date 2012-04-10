# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase'
require 'app/models/budget_allocation'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/direct_purchase_budget_allocation_item'
require 'app/models/supply_authorization'
require 'app/models/modality_limit'
require 'app/business/direct_purchase_modality_limit_verificator'

describe DirectPurchase do
  it 'should return id as to_s method' do
    subject.id = 1

    subject.to_s.should eq '1'
  end

  it { should belong_to :legal_reference }
  it { should belong_to :provider }
  it { should belong_to :budget_unit }
  it { should belong_to :licitation_object }
  it { should belong_to :delivery_location }
  it { should belong_to :employee }
  it { should belong_to :payment_method }
  it { should belong_to :period }
  it { should have_many(:direct_purchase_budget_allocations).dependent(:destroy).order(:id) }
  it { should have_one(:supply_authorization).dependent(:restrict) }

  it 'should return 0 for total items value of all budget allocations when have no allocations' do
    subject.direct_purchase_budget_allocations.should be_empty

    subject.total_allocations_items_value.should eq 0
  end

  it 'should return total items value of all budget allocations' do
    subject.stub(:direct_purchase_budget_allocations).and_return([
      double(:total_items_value => 20),
      double(:total_items_value => 30),
      double(:total_items_value => 45)
    ])

    subject.total_allocations_items_value.should eq 95
  end

  it 'should return 0 for licitation_exemption when no licitation object' do
    subject.licitation_exemption.should eq 0
  end

  it 'should propagate licitation_exemption method to licitation object passing modality' do
    licitation_object = double
    subject.stub(:licitation_object).and_return(licitation_object)
    subject.stub(:modality).and_return(DirectPurchaseModality::MATERIAL_OR_SERVICE)

    licitation_object.should_receive(:licitation_exemption).with(DirectPurchaseModality::MATERIAL_OR_SERVICE)

    subject.licitation_exemption
  end

  it 'should delegate purchase_licitation_exemption to licitation object' do
    subject.licitation_object_purchase_licitation_exemption.should eq nil

    subject.stub(:licitation_object).and_return(double(:purchase_licitation_exemption => 300.0))

    subject.licitation_object_purchase_licitation_exemption.should eq 300.0
  end

  it 'should delegate build_licitation_exemption to licitation object' do
    subject.licitation_object_build_licitation_exemption.should eq nil

    subject.stub(:licitation_object).and_return(double(:build_licitation_exemption => 200.0))

    subject.licitation_object_build_licitation_exemption.should eq 200.0
  end

  context "validations" do
    it "the duplicated budget_allocations should be invalid except the first" do
      allocation_one = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 1)
      allocation_two = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 1)

      subject.valid?

      allocation_one.errors.messages[:budget_allocation_id].should be_nil
      allocation_two.errors.messages[:budget_allocation_id].should include "já está em uso"
    end

    it "the diferent budget_allocations should be valid" do
      allocation_one = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 1)
      allocation_two = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 2)

      subject.valid?

      allocation_one.errors.messages[:budget_allocation_id].should be_nil
      allocation_two.errors.messages[:budget_allocation_id].should be_nil
    end

    it { should validate_presence_of :status }
    it { should validate_presence_of :year }
    it { should validate_presence_of :date }
    it { should validate_presence_of :legal_reference }
    it { should validate_presence_of :modality }
    it { should validate_presence_of :budget_unit }
    it { should validate_presence_of :licitation_object }
    it { should validate_presence_of :delivery_location }
    it { should validate_presence_of :provider }
    it { should validate_presence_of :employee }
    it { should validate_presence_of :payment_method }
    it { should validate_presence_of :period }
    it { should validate_presence_of :pledge_type }

    context '#authorized?' do
      it 'should return true when associated with supply_authorization' do
        subject.stub(:supply_authorization).and_return(double)
        subject.should be_authorized
      end

      it 'should return false when not associated with supply_authorization' do
        subject.stub(:supply_authorization).and_return(nil)
        subject.should_not be_authorized
      end
    end

    it 'should have at least one budget allocation' do
      subject.direct_purchase_budget_allocations.should be_empty

      subject.valid?

      subject.errors[:direct_purchase_budget_allocations].should include 'é necessário cadastrar pelo menos uma dotação'
    end

    it 'should have error when limit verificator returns false' do
      subject.stub(:licitation_object).and_return(double)
      subject.stub(:modality).and_return(double)

      DirectPurchaseModalityLimitVerificator.any_instance.stub(:verify_limit_value!).and_return(false)

      subject.valid?

      subject.errors[:total_allocations_items_value].should include 'está acima do valor disponível no limite em vigor para esta modalidade'
    end

    it 'should not have error when limit verificator returns true' do
      subject.stub(:licitation_object).and_return(double)
      subject.stub(:modality).and_return(double)

      DirectPurchaseModalityLimitVerificator.any_instance.stub(:verify_limit_value!).and_return(true)

      subject.valid?

      subject.errors[:total_allocations_items_value].should_not include 'está acima do valor disponível no limite em vigor para esta modalidade'
    end
  end
end
