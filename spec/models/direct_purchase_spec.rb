# encoding: utf-8
require 'model_helper'
require 'lib/signable'
require 'lib/annullable'
require 'app/models/resource_annul'
require 'app/models/direct_purchase'
require 'app/models/budget_allocation'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/direct_purchase_budget_allocation_item'
require 'app/models/supply_authorization'
require 'app/models/modality_limit'
require 'app/business/direct_purchase_modality_limit_verificator'
require 'app/models/purchase_solicitation_budget_allocation_item'

describe DirectPurchase do
  it 'should return code/year as to_s method' do
    subject.code = 1
    subject.year = 2012

    expect(subject.to_s).to eq '1/2012'
  end

  it { should belong_to :legal_reference }
  it { should belong_to :creditor }
  it { should belong_to :budget_structure }
  it { should belong_to :licitation_object }
  it { should belong_to :delivery_location }
  it { should belong_to :employee }
  it { should belong_to :payment_method }
  it { should belong_to :purchase_solicitation }
  it { should belong_to :price_registration }

  it { should have_many(:items).through(:direct_purchase_budget_allocations) }
  it { should have_many(:materials).through(:items) }
  it { should have_many(:direct_purchase_budget_allocations).dependent(:destroy).order(:id) }

  it { should have_one(:supply_authorization).dependent(:restrict) }
  it { should have_one(:annul).dependent(:destroy) }

  it { should auto_increment(:code).by(:year) }

  it { should validate_duplication_of(:budget_allocation_id).on(:direct_purchase_budget_allocations) }

  it 'should return 0 for licitation_exemption when no licitation object' do
    expect(subject.licitation_exemption).to eq 0
  end

  it 'should propagate licitation_exemption method to licitation object passing modality' do
    licitation_object = double
    subject.stub(:licitation_object).and_return(licitation_object)
    subject.stub(:modality).and_return(DirectPurchaseModality::MATERIAL_OR_SERVICE)

    licitation_object.should_receive(:licitation_exemption).with(DirectPurchaseModality::MATERIAL_OR_SERVICE)

    subject.licitation_exemption
  end

  it 'should delegate purchase_licitation_exemption to licitation object' do
    expect(subject.licitation_object_purchase_licitation_exemption).to eq nil

    subject.stub(:licitation_object).and_return(double(:purchase_licitation_exemption => 300.0))

    expect(subject.licitation_object_purchase_licitation_exemption).to eq 300.0
  end

  it 'should delegate build_licitation_exemption to licitation object' do
    expect(subject.licitation_object_build_licitation_exemption).to eq nil

    subject.stub(:licitation_object).and_return(double(:build_licitation_exemption => 200.0))

    expect(subject.licitation_object_build_licitation_exemption).to eq 200.0
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

    context "budget structure validation" do
      it { should validate_presence_of :budget_structure }
    end

    it { should validate_presence_of :year }
    it { should validate_presence_of :date }
    it { should validate_presence_of :legal_reference }
    it { should validate_presence_of :modality }
    it { should validate_presence_of :licitation_object }
    it { should validate_presence_of :delivery_location }
    it { should validate_presence_of :creditor }
    it { should validate_presence_of :employee }
    it { should validate_presence_of :payment_method }
    it { should validate_presence_of :delivery_term }
    it { should validate_presence_of :delivery_term_period }
    it { should validate_presence_of :pledge_type }

    context '#remove_purchase_solicitation' do
      it 'should set purchase solicitation to nil' do
        subject.should_receive(:update_column).with(:purchase_solicitation_id, nil)
        subject.remove_purchase_solicitation!
      end
    end

    context '#authorized?' do
      it 'should return true when associated with supply_authorization' do
        subject.stub(:supply_authorization).and_return(double)
        expect(subject).to be_authorized
      end

      it 'should return false when not associated with supply_authorization' do
        subject.stub(:supply_authorization).and_return(nil)
        expect(subject).not_to be_authorized
      end
    end

    it 'should have at least one budget allocation' do
      expect(subject.direct_purchase_budget_allocations).to be_empty

      subject.valid?

      expect(subject.errors[:direct_purchase_budget_allocations]).to include 'é necessário cadastrar pelo menos uma dotação'
    end

    it 'should have error when limit verificator returns false' do
      subject.stub(:licitation_object).and_return(double(:to_s => 'objeto de licitacao'))
      subject.stub(:modality).and_return(double)

      DirectPurchaseModalityLimitVerificator.any_instance.stub(:value_less_than_available_limit?).and_return(false)
      DirectPurchaseModalityLimitVerificator.any_instance.stub(:current_limit).and_return(5)

      subject.valid?

      expect(subject.errors[:total_allocations_items_value]).to include "está acima do valor acumulado para este objeto (objeto de licitacao), está acima do limite permitido (5)"
    end

    it 'should not have error when limit verificator returns true' do
      subject.stub(:licitation_object).and_return(double)
      subject.stub(:modality).and_return(double)

      DirectPurchaseModalityLimitVerificator.any_instance.stub(:value_less_than_available_limit?).and_return(true)

      subject.valid?

      expect(subject.errors[:total_allocations_items_value]).to_not include 'está acima do valor disponível no limite em vigor para esta modalidade'
    end

    context "purchase_solicitations" do
      let(:purchase_solicitation) do
        double(:can_be_grouped? => true)
      end

      it "should not have a purchase solicitation that can't generate direct purchases" do
        purchase_solicitation.stub(:can_be_grouped? => false)
        subject.stub(:purchase_solicitation_id_changed? => true)
        subject.stub(:purchase_solicitation => purchase_solicitation)

        subject.valid?

        expect(subject.errors[:purchase_solicitation]).to include 'não pode gerar compras diretas com a situação atual'
      end
    end
  end

  describe '#total_direct_purchase_budget_allocations_sum' do
    it 'should return sum of total_items_value' do
      item1 = double(:item1, :total_items_value =>10, :marked_for_destruction? => false)
      item2 = double(:item1, :total_items_value =>1, :marked_for_destruction? => false)

      subject.stub(:direct_purchase_budget_allocations).and_return([item1, item2])

      subject.total_direct_purchase_budget_allocations_sum.should eq 11
    end

    it 'should return sum of total_items_value ignoring itens marked_for_destruction' do
      item1 = double(:item1, :total_items_value =>10, :marked_for_destruction? => true)
      item2 = double(:item1, :total_items_value =>1, :marked_for_destruction? => false)

      subject.stub(:direct_purchase_budget_allocations).and_return([item1, item2])

      subject.total_direct_purchase_budget_allocations_sum.should eq 1
    end
  end

  context '#annul' do
    let :annul do
      double(:annul)
    end

    it 'should be annuled when annul is present' do
      subject.stub(:annul).and_return(annul)

      expect(subject.annulled?).to be true
    end

    it 'should not be annuled when annul is not present' do
      expect(subject.annulled?).to be false
    end
  end

  describe '#status' do
    it "should be 'completed' when not annulled" do
      subject.stub(:annulled?).and_return(false)

      expect(subject.status).to eq DirectPurchaseStatus::COMPLETED
    end

    it "should be 'annulled' when annulled" do
      subject.stub(:annulled?).and_return(true)

      expect(subject.status).to eq DirectPurchaseStatus::ANNULLED
    end
  end

  context 'with two items on purchase_solicitation_items' do
    before do
      subject.should_receive(:purchase_solicitation_items).at_least(1).times.
              and_return([item, item2])
    end

    let(:item)  { double(:item) }
    let(:item2) { double(:item2) }

    describe 'fulfill_purchase_solicitation_items' do

      it 'should fulfill items' do
        item.should_receive(:fulfill).with(subject)
        item2.should_receive(:fulfill).with(subject)

        subject.fulfill_purchase_solicitation_items
      end
    end

    describe 'remove_fulfill_purchase_solicitation_items' do

      it 'should fulfill items' do
        item.should_receive(:fulfill).with(nil)
        item2.should_receive(:fulfill).with(nil)

        subject.remove_fulfill_purchase_solicitation_items
      end
    end

    describe 'partially_fulfilled_purchase_solicitation_items' do
      it 'should fulfill items' do
        item.should_receive(:partially_fulfilled!)
        item2.should_receive(:partially_fulfilled!)

        subject.partially_fulfilled_purchase_solicitation_items
      end
    end

    describe 'attend_purchase_solicitation_items' do
      it 'should attend purchase solicitation items' do
        subject.purchase_solicitation_items.should_receive(:attend!)

        subject.attend_purchase_solicitation_items
      end
    end
  end
end
