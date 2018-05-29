require_relative 'sales_engine'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'math_helper'

class SalesAnalyst
  include MathHelper

  attr_reader :items,
              :merchants,
              :invoices,
              :items_by_merchant,
              :high_item_count_list,
              :invoices_by_merchant,
              :high_invoice_count_merchants,
              :average_invoices_per_merchant_standard_deviation

  def initialize(merchants, items, invoices)
    @items = items.items
    @merchants = merchants.merchants
    @invoices = invoices.invoices
    @items_by_merchant ||= group_items
    @invoices_by_merchant ||= group_invoices_by_merchant
    @high_item_count_list ||= list_of_high_item_count_merchant_ids
    @average_invoices_per_merchant_standard_deviation ||= average_invoices_per_merchant_standard_deviation
    @high_invoice_count_merchants ||= high_invoice_count_merchants
  end

  def golden_items
    @items.find_all do |item|
      item.unit_price > (standard_deviation_for_items * 2)
    end
  end

  def average_items_per_merchant
    BigDecimal.new((@items.length.to_f / @items_by_merchant.length), 3).to_f
  end

  def average_average_price_per_merchant
    average_price = @items_by_merchant.map { |merchant_id, items|
      calculate_average_price(merchant_id)}.reduce(:+) / @merchants.length
    BigDecimal.new(average_price.to_f, 5)
  end

  def average_item_price_for_merchant(merchant_id)
    BigDecimal.new(calculate_average_price(merchant_id).to_f, 4)
  end

  def calculate_average_price(merchant_id)
    @items_by_merchant[merchant_id].map { |item| item.unit_price}.reduce(:+) / @items_by_merchant[merchant_id].length
  end

  def merchants_with_high_item_count
    @merchants.find_all do |merchant|
      @high_item_count_list.include?(merchant.id)
    end
  end

  def list_of_high_item_count_merchant_ids
    @items_by_merchant.map do |merchant_id, merchant|
      if merchant.count > (average_items_per_merchant_standard_deviation * 2)
        merchant_id
      end
    end.compact.uniq
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

  def group_invoices_by_merchant
    invoices_by_merchant = @invoices.each_with_object({}) do |invoice, accumulator|
      if accumulator[invoice.merchant_id]
        accumulator[invoice.merchant_id] << invoice
      else
        accumulator[invoice.merchant_id] = [invoice]
      end
    end
  end

  def calculate_mean_for_items
    @items.map { |item| item.unit_price }.reduce(:+) / @items.length
  end

  def deviation_list_for_items(mean)
    @items.map do |item|
      item.unit_price - mean
    end
  end

  def standard_deviation_for_items
    mean = calculate_mean_for_items
    squares = square_deviations(deviation_list_for_items(mean))
    sum = sum_of_deviations(squares)
    BigDecimal.new(Math.sqrt(sum / (@items.length - 1)), 3).to_f
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    squares = square_deviations(list_of_deviations(mean))
    sum = sum_of_deviations(squares)
    BigDecimal.new(Math.sqrt(sum / (@items_by_merchant.length - 1)), 3).to_f
  end

  def list_of_deviations(mean)
    @items_by_merchant.map do |merchant_id, merchant|
      merchant.count - mean
    end
  end

  def list_of_invoices_per_merchant_deviations(mean)
    @invoices_by_merchant.map do |merchant_id, invoice|
      invoice.count - mean
    end
  end

  def average_invoices_per_merchant
    BigDecimal.new((@invoices.length.to_f / @invoices_by_merchant.length), 4).to_f
  end

  def average_invoices_per_merchant_standard_deviation
    mean = average_invoices_per_merchant
    squares = square_deviations(list_of_invoices_per_merchant_deviations(mean))
    sum = sum_of_deviations(squares)
    BigDecimal.new(Math.sqrt(sum / (@invoices_by_merchant.length - 1)), 3).to_f
  end

  def high_invoice_count_merchants
    high_invoice_merchants = []
    @invoices_by_merchant.find_all do |merchant_id, invoice|
      if invoice.count > (average_invoices_per_merchant + (@average_invoices_per_merchant_standard_deviation * 2))
        high_invoice_merchants << merchant_id
      end
    end
    return high_invoice_merchants
  end

  def top_merchants_by_invoice_count
    top_merchants = []
    @merchants.map do |merchant|
       if @high_invoice_count_merchants.include?(merchant.id)
         top_merchants << merchant
       end
    end
    return top_merchants
  end
end
# sales_analyst.top_merchants_by_invoice_count # => [merchant, merchant, merchant]
# Who are our lowest performing merchants?
# Which merchants are more than two standard deviations below the mean?
#
# sales_analyst.bottom_merchants_by_invoice_count # => [merchant, merchant, merchant]
# Which days of the week see the most sales?
# On which days are invoices created at more than one standard deviation above the mean?
#
# sales_analyst.top_days_by_invoice_count # => ["Sunday", "Saturday"]
# What percentage of invoices are not shipped?
# What percentage of invoices are shipped vs pending vs returned? (takes symbol as argument)
#
# sales_analyst.invoice_status(:pending) # => 29.55
# sales_analyst.invoice_status(:shipped) # => 56.95
# sales_analyst.invoice_status(:returned) # => 13.5
