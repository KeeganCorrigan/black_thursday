# frozen_string_literal: true

require_relative 'sales_analyst'
require_relative 'math_helper'

class MerchantItemAnalyst
  include MathHelper

  attr_reader :items,
              :items_by_merchant,
              :merchants,
              :merchant_repo

  def initialize(merchants, items, merchant_repo = nil)
    @merchants = merchants
    @items = items
    @merchant_repo = merchant_repo
    @items_by_merchant ||= group_items_by_merchant
    @standard_deviation ||= average_items_per_merchant_standard_deviation
  end

  def group_items_by_merchant
    @items.group_by(&:merchant_id)
  end

  def average_items_per_merchant
    BigDecimal((@items.length.to_f / @items_by_merchant.length), 3).to_f
  end

  def average_average_price_per_merchant
    price = @items_by_merchant.map do |merchant_id, _items|
      calculate_average_price(merchant_id)
    end
    average_price = price.reduce(:+) / @merchants.length
    BigDecimal(average_price.to_f, 5)
  end

  def calculate_average_price(merchant_id)
    unit_prices = @items_by_merchant[merchant_id].map(&:unit_price)
    unit_prices.reduce(:+) / @items_by_merchant[merchant_id].length
  end

  def average_item_price_for_merchant(merchant_id)
    BigDecimal(calculate_average_price(merchant_id).to_f, 4)
  end

  def merchants_with_high_item_count
    @merchants.find_all do |merchant|
      list_of_high_item_count_merchant_ids.include?(merchant.id)
    end
  end

  def list_of_high_item_count_merchant_ids
    @items_by_merchant.map do |merchant_id, merchant|
      if merchant.count > (@standard_deviation * 2)
        merchant_id
      end
    end.compact.uniq
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    squares = square_deviations(list_of_deviations(@items_by_merchant, mean))
    sum = sum_of_deviations(squares)
    BigDecimal(Math.sqrt(sum / (@items_by_merchant.length - 1)), 3).to_f
  end

  def merchants_with_only_one_item
    @items_by_merchant.each_with_object([]) do |(merchant_id, items), collector|
      collector << @merchant_repo.find_by_id(merchant_id) if items.length == 1
      collector
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    converted_month = convert_month_to_number(month)
    merchants_with_only_one_item.find_all do |merchant|
      merchant.created_at.split('-')[1].to_i == converted_month
    end
  end

  def convert_month_to_number(month)
    Date::MONTHNAMES.index(month)
  end
end
