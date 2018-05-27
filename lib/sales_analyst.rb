require_relative 'sales_engine'

class SalesAnalyst
  attr_reader :parent, :items, :items_by_merchant

  def initialize(parent)
    @parent = parent
    @items ||= get_items
    @items_by_merchant ||= group_items
  end

  def get_items
    item_repo = parent.from_csv({:items => "./data/items.csv"})
    item_repo.items.items
  end

  def group_items
    items_by_merchant = @items.each_with_object({}) do |item, accumulator|
      if accumulator[item.merchant_id]
        accumulator[item.merchant_id] << item
      else
        accumulator[item.merchant_id] = [item]
      end
    end
  end
end
