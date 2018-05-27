require_relative 'sales_engine'

class SalesAnalyst
  attr_reader :parent

  def initialize(parent)
    @parent = parent
    @items ||= get_items
  end

  def get_items
    item_repo = parent.from_csv({:items => "./data/items.csv"})
    binding.pry
  end
end
