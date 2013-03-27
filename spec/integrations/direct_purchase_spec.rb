require 'spec_helper'

describe DirectPurchase do
  describe ".ordered" do
    it "should order by year DESC and budget_structure DESC" do
      direct_purchase_2012_1 = DirectPurchase.make!(:compra)
      direct_purchase_2012_2 = DirectPurchase.make!(:compra_nao_autorizada)
      direct_purchase_2011 = DirectPurchase.make!(:compra_2011)

      expect(DirectPurchase.ordered.to_a).to eq [direct_purchase_2012_2, direct_purchase_2012_1, direct_purchase_2011]
    end
  end
end
