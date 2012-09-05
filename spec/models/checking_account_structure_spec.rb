require 'model_helper'
require 'app/models/checking_account_structure'

describe CheckingAccountStructure do
  it 'should return name as to_s' do
    subject.name = 'Fonte de Recursos'
    expect(subject.to_s).to eq 'Fonte de Recursos'
  end

  it { should belong_to :checking_account_of_fiscal_account }
  it { should belong_to :checking_account_structure_information }

  it { should validate_presence_of :checking_account_of_fiscal_account }
  it { should validate_presence_of :name }
  it { should validate_presence_of :tag }
end