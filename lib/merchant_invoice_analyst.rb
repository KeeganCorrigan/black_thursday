# frozen_string_literal: true

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
    @standard_deviation ||= average_invoices_per_merchant_standard_deviation
    @average_invoice ||= average_invoices_per_merchant
  end

  def average_invoices_per_merchant
    BigDecimal(@invoices.length.to_f / @invoices_by_merchant.length, 4).to_f
  end

  def average_invoices_per_merchant_standard_deviation
    mean = average_invoices_per_merchant
    squares = square_deviations(list_of_deviations(@invoices_by_merchant, mean))
    sum = sum_of_deviations(squares)
    BigDecimal(Math.sqrt(sum / (@invoices_by_merchant.length - 1)), 3).to_f
  end

  def low_invoice_count_merchants
    @invoices_by_merchant.each_with_object([]) do |(id, invoice), collector|
      if invoice.count < (@average_invoice - (@standard_deviation * 2))
        collector << id
      end
      collector
    end
  end

  def bottom_merchants_by_invoice_count
    @merchants.find_all do |merchant|
      low_invoice_count_merchants.include?(merchant.id)
    end
  end

  def high_invoice_count_merchants
    @invoices_by_merchant.each_with_object([]) do |(id, invoice), collector|
      if invoice.count > (@average_invoice + (@standard_deviation * 2))
        collector << id
      end
    end
  end

  def top_merchants_by_invoice_count
    @merchants.find_all do |merchant|
      high_invoice_count_merchants.include?(merchant.id)
    end
  end
end
