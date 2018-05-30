require_relative 'sales_engine'
require_relative 'item'
require_relative 'repository_helper'
require 'time'
require 'bigdecimal'

class ItemRepository < RepositoryHelper
  attr_reader :table,
              :items

  def initialize(table)
    @table ||= create_items(table)
    @items = @table
  end

  def create_items(table)
    table.map do |row|
      Item.new(row)
    end
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
    attributes[:id] = generate_new_id
    @items << Item.new(attributes)
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
end
