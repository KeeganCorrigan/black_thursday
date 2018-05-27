require_relative 'sales_engine'
require_relative 'item'

class ItemRepository
  attr_reader :items

  def initialize(items)
    @items ||= create_items(items)
  end

  def create_items(items)
    items.map do |row|
      Item.new(row)
    end
  end
end
