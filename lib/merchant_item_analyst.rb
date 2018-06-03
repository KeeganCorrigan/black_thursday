require_relative 'sales_analyst'
require_relative 'math_helper'

class MerchantItemAnalyst
  include MathHelper

  attr_reader :items,
              :items_by_merchant,
              :merchants,
              :merchant_repo

  def initialize(items_by_merchant, merchants, items, merchant_repo = nil)
    @items_by_merchant = items_by_merchant
    @merchants = merchants
    @items = items
    @merchant_repo = merchant_repo
  end

  def average_items_per_merchant
    BigDecimal.new((@items.length.to_f / @items_by_merchant.length), 3).to_f
  end

  def average_average_price_per_merchant
    average_price = @items_by_merchant.map {|merchant_id, items|
    calculate_average_price(merchant_id)}.reduce(:+) / @merchants.length
    BigDecimal.new(average_price.to_f, 5)
  end

  def calculate_average_price(merchant_id)
    @items_by_merchant[merchant_id].map {|item| item.unit_price}.reduce(:+) / @items_by_merchant[merchant_id].length
  end

  def average_item_price_for_merchant(merchant_id)
    BigDecimal.new(calculate_average_price(merchant_id).to_f, 4)
  end

  def merchants_with_high_item_count
    @merchants.find_all {|merchant| list_of_high_item_count_merchant_ids.include?(merchant.id)}
  end

  def list_of_high_item_count_merchant_ids
    @items_by_merchant.map do |merchant_id, merchant|
      if merchant.count > (average_items_per_merchant_standard_deviation * 2)
        merchant_id
      end
    end.compact.uniq
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    squares = square_deviations(list_of_deviations(@items_by_merchant, mean))
    sum = sum_of_deviations(squares)
    BigDecimal.new(Math.sqrt(sum / (@items_by_merchant.length - 1)), 3).to_f
  end

  def merchants_with_only_one_item
    @items_by_merchant.inject([]) do |collector, (merchant_id, items)|
      collector << @merchant_repo.find_by_id(merchant_id) if items.length == 1
      collector
    end
  end
end
