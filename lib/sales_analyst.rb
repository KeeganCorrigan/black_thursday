require_relative 'sales_engine'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'math_helper'

class SalesAnalyst
  include MathHelper

  attr_reader :items,
              :merchants,
              :invoices,
              :items_by_merchant,
              :invoice_items,
              :transactions,
              :high_item_count_list,
              :invoices_by_merchant,
              :high_invoice_count_merchants,
              :low_invoice_count_merchants,
              :transactions_by_invoice,
              :invoice_items_by_invoice_id,
              :average_invoices_per_merchant_standard_deviation

  def initialize(merchants, items, invoices, invoice_items, transactions)
    @items = items.items
    @merchants = merchants.merchants
    @invoices = invoices.invoices
    @invoice_items = invoice_items.invoice_items
    @transactions = transactions.transactions
    @items_by_merchant ||= group_items
    @invoices_by_merchant ||= group_invoices_by_merchant
    @high_item_count_list ||= list_of_high_item_count_merchant_ids
    @average_invoices_per_merchant_standard_deviation ||= average_invoices_per_merchant_standard_deviation
    @high_invoice_count_merchants ||= high_invoice_count_merchants
    @low_invoice_count_merchants ||= low_invoice_count_merchants
    @transactions_by_invoice ||= group_transactions_by_invoice
    @invoice_items_by_invoice_id ||= group_invoice_items_by_invoice_id
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
    average_price = @items_by_merchant.map {|merchant_id, items|
      calculate_average_price(merchant_id)}.reduce(:+) / @merchants.length
    BigDecimal.new(average_price.to_f, 5)
  end

  def average_item_price_for_merchant(merchant_id)
    BigDecimal.new(calculate_average_price(merchant_id).to_f, 4)
  end

  def calculate_average_price(merchant_id)
    @items_by_merchant[merchant_id].map {|item| item.unit_price}.reduce(:+) / @items_by_merchant[merchant_id].length
  end

  def merchants_with_high_item_count
    @merchants.find_all {|merchant| @high_item_count_list.include?(merchant.id)}
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

  def deviation_list_for_items(mean)
    @items.map {|item| item.unit_price - mean}
  end

  def standard_deviation_for_items
    mean = calculate_mean(@items)
    squares = square_deviations(deviation_list_for_items(mean))
    sum = sum_of_deviations(squares)
    BigDecimal.new(Math.sqrt(sum / (@items.length - 1)), 3).to_f
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    squares = square_deviations(list_of_deviations(@items_by_merchant, mean))
    sum = sum_of_deviations(squares)
    BigDecimal.new(Math.sqrt(sum / (@items_by_merchant.length - 1)), 3).to_f
  end

  def average_invoices_per_merchant
    BigDecimal.new((@invoices.length.to_f / @invoices_by_merchant.length), 4).to_f
  end

  def average_invoices_per_merchant_standard_deviation
    mean = average_invoices_per_merchant
    squares = square_deviations(list_of_deviations(@invoices_by_merchant, mean))
    sum = sum_of_deviations(squares)
    BigDecimal.new(Math.sqrt(sum / (@invoices_by_merchant.length - 1)), 3).to_f
  end

  def low_invoice_count_merchants
    low_invoice_merchants = []
    @invoices_by_merchant.find_all do |merchant_id, invoice|
      if invoice.count < (average_invoices_per_merchant - (@average_invoices_per_merchant_standard_deviation * 2))
        low_invoice_merchants << merchant_id
      end
    end
    return low_invoice_merchants
  end

  def bottom_merchants_by_invoice_count
    @merchants.find_all {|merchant| @low_invoice_count_merchants.include?(merchant.id)}
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
    @merchants.find_all {|merchant| @high_invoice_count_merchants.include?(merchant.id)}
  end

  def invoices_created_by_day
    @invoices.map {|invoice| invoice.created_at.wday}
  end

  def count_invoices_created_by_day
    invoices_created_by_day.each_with_object(Hash.new(0)) {|day,hash| hash[day] += 1}
  end

  def top_days_by_invoice_count
    [Date::DAYNAMES[count_invoices_created_by_day.max_by {|day, value| value}.first]]
  end

  def invoice_status(status)
    BigDecimal.new(((@invoices.find_all { |invoice| invoice.status == status}.count).to_f / (total_invoices = @invoices.length).to_f) * 100, 4)
  end

  def group_transactions_by_invoice
    @transactions.group_by {|transaction| transaction.invoice_id}
  end

  def group_invoice_items_by_invoice_id
    @invoice_items.group_by {|invoice_item| invoice_item.invoice_id}
  end

  def invoice_paid_in_full?(invoice_id)
    return false if @transactions_by_invoice[invoice_id].nil? 
    @transactions_by_invoice[invoice_id].all? {|transaction| transaction.result == :success}
  end
end

# sales_analyst.invoice_paid_in_full?(invoice_id) returns true if the Invoice with the corresponding id is paid in full
# sales_analyst.invoice_total(invoice_id) returns the total $ amount of the Invoice with the corresponding id.
# Notes:
#
# Failed charges should never be counted in revenue totals or statistics.
# An invoice is considered paid in full if it has a successful transaction
