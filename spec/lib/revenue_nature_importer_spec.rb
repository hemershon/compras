# encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/revenue_nature_importer'
require 'active_support/core_ext/object/try'

describe RevenueNatureImporter do
  subject do
    RevenueNatureImporter.new(null_storage, category_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  let :category_storage do
    double
  end

  it 'imports revenue natures' do
    category_storage.stub(:find_by_code).with('1').and_return(double(:id => 1))
    category_storage.stub(:find_by_code).with('2').and_return(double(:id => 2))
    category_storage.stub(:find_by_code).with('7').and_return(double(:id => 3))
    category_storage.stub(:find_by_code).with('8').and_return(double(:id => 4))
    category_storage.stub(:find_by_code).with('9').and_return(double(:id => 5))

    null_storage.should_receive(:create!).with('code' => '4', 'description' => 'RECEITA AGROPECUÁRIA', 'parent_id' => 1)
    null_storage.should_receive(:create!).with('code' => '5', 'description' => 'RECEITA INDUSTRIAL', 'parent_id' => 1)
    null_storage.should_receive(:create!).with('code' => '5', 'description' => 'RECEITA INDUSTRIAL - INTRA-ORÇAMENTÁRIAS', 'parent_id' => 3)
    null_storage.should_receive(:create!).with('code' => '5', 'description' => 'OUTRAS RECEITAS DE CAPITAL - INTRA-ORÇAMENTÁRIAS', 'parent_id' => 4)

    subject.import!
  end
end
