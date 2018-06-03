require_relative 'sales_analyst'
require_relative 'math_helper'

class MerchantInvoiceAnalyst
  include MathHelper

  attr_reader :invoices_by_merchant,
              :merchants,
              :invoices

  def initialize(invoices_by_merchant, merchants, invoices)
    @invoices_by_merchant = invoices_by_merchant
    @merchants = merchants
    @invoices = invoices
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
    @invoices_by_merchant.inject([]) do |collector, (merchant_id, invoice)|
      if invoice.count < (average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2))
        collector << merchant_id
      end
      collector
    end
  end

  def bottom_merchants_by_invoice_count
    @merchants.find_all {|merchant| low_invoice_count_merchants.include?(merchant.id)}
  end

  def high_invoice_count_merchants
    high_invoice_merchants = []
    @invoices_by_merchant.find_all do |merchant_id, invoice|
      if invoice.count > (average_invoices_per_merchant + (average_invoices_per_merchant_standard_deviation * 2))
        high_invoice_merchants << merchant_id
      end
    end
    return high_invoice_merchants
  end

  def top_merchants_by_invoice_count
    @merchants.find_all {|merchant| high_invoice_count_merchants.include?(merchant.id)}
  end
end
