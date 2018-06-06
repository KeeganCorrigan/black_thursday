# frozen_string_literal: true

require_relative 'sales_engine'
require_relative 'item'
require_relative 'repository_helper'

class ItemRepository < RepositoryHelper
  attr_reader :items

  def initialize(items)
    @table ||= create_items(items)
    @items = @table
  end

  def create_items(table)
    table.map do |row|
      Item.new(row)
    end
  end

  def find_all_with_description(description)
    @items.find_all do |item|
      item.description.downcase.include?(description.downcase)
    end
  end

  def find_all_by_price(price)
    @items.find_all { |item| item.unit_price == price }
  end

  def find_all_by_price_in_range(range)
    @items.find_all { |item| range.include?(item.unit_price) }
  end

  def create(attributes)
    attributes[:id] = generate_new_id
    @items << Item.new(attributes)
  end

  def update(id, data)
    return if data.empty?
    item = find_by_id(id)
    item.created_at = item.created_at
    item.unit_price = data[:unit_price] unless data[:unit_price].nil?
    item.name = data[:name] unless data[:name].nil?
    item.description = data[:description] unless data[:description].nil?
    item.updated_at = Time.now
  end
end
