# encoding: utf-8
require 'model_helper'
require 'app/models/expense_nature'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/material'
require 'app/models/budget_allocation'
require 'app/models/pledge'

describe ExpenseNature do
  it 'should return expense nature and description as to_s method' do
    subject.expense_nature = '4.4.20.03.11111111'
    subject.description = "Descrição"
    subject.to_s.should eq '4.4.20.03.11111111 - Descrição'
  end

  it { should belong_to :descriptor }
  it { should belong_to :regulatory_act }
  it { should belong_to :expense_group }
  it { should belong_to :expense_modality }
  it { should belong_to :expense_element }
  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:restrict) }
  it { should have_many(:materials).dependent(:restrict) }
  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }

  it { should validate_presence_of :expense_nature }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :description }
  it { should validate_presence_of :expense_group }
  it { should validate_presence_of :expense_modality }
  it { should validate_presence_of :expense_element }
  it { should validate_presence_of :expense_split }
  it { should validate_presence_of :expense_category }
  it { should validate_presence_of :descriptor }
  it { should validate_presence_of :regulatory_act }

  it { should allow_value('12').for(:expense_split) }
  it { should_not allow_value('4a').for(:expense_split) }
end
