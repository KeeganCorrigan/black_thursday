require_relative 'sales_engine'
require_relative 'item'
require 'time'
require 'bigdecimal'

class ItemRepository
  attr_reader :items, :parent

  def initialize(items, parent)
    @items ||= create_items(items)
    @parent = parent
  end

  def inspect
   "#<#{self.class} #{@items.size} rows>"
 end

  def create_items(items)
    items.map do |row|
      Item.new(row)
    end
  end

  def all
    @items
  end

  def find_by_id(id)
    @items.find { |item| item.id == id }
  end

  def find_by_name(name)
    @items.find { |item| item.name.downcase == name.downcase }
  end

  def find_all_with_description(description)
    @items.find_all { |item| item.description.downcase.include?(description.downcase) }
  end

  def find_all_by_price(price)
    @items.find_all { |item| (item.unit_price) == price }
  end

  def find_all_by_price_in_range(range)
    @items.find_all { |item| range.include?(item.unit_price) }
  end

  def find_all_by_merchant_id(merchant_id)
    @items.find_all { |item| item.merchant_id == merchant_id }
  end

  def create(attributes)
    attributes[:id] = generate_id_for_new_item
    @items << Item.new(attributes)
  end

  def generate_id_for_new_item
    (@items.max_by { |item| item.id }).id + 1
  end

  def update(id, attributes)
    return if attributes.empty?
    item_to_update = find_by_id(id)
    item_to_update.created_at = item_to_update.created_at
    item_to_update.unit_price = attributes[:unit_price] if attributes[:unit_price] != nil
    item_to_update.name = attributes[:name] if attributes[:name] != nil
    item_to_update.description = attributes[:description] if attributes[:description] != nil
    item_to_update.updated_at = Time.now
  end

  def delete(id)
    item_to_delete = find_by_id(id)
    @items.delete(item_to_delete)
  end
end
