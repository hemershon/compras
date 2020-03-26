module Report::BalanceHelper

  def self.get_licitation_processes_ratifications(licitation_processes, creditor)
    lic_pro = LicitationProcessRatification.where(licitation_process_id:licitation_processes,creditor_id:creditor)[0]
    LicitationProcessRatificationItem.where(licitation_process_ratification_id:lic_pro.id)
  end

  def self.get_balance(contract, item)
    supply_orders = SupplyOrder.joins(:contract, :items)
    supply_orders = supply_orders.where("compras_supply_order_items.material_id = #{item.material.id}")
    supply_orders = supply_orders.where(contract_id: contract.id)

    total_provided = supply_orders.sum(:quantity) if supply_orders.any?
    total_bid = contract.licitation_process.items.where(material_id: item.material.id).sum(:quantity)

    balance = total_bid.to_i - total_provided.to_i
    balance
  end

  def self.get_quantity_item_licitation(licitation_process, material)
    licitation_process.items.where(material_id: material.id).last.quantity
  end


  def self.get_quantity_item_supply_order(contract, material)
    quantity_provided = contract.supply_orders.joins(:items).where(" compras_supply_order_items.material_id = ?", material.id).sum("compras_supply_order_items.quantity")
    quantity_provided.to_i
  end

  def self.get_quantity_bid(licitation_process, material_ids)
    licitation_process.items.where(material_id: material_ids.uniq).sum(:quantity)
  end

end