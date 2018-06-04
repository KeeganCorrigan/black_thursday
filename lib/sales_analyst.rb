# frozen_string_literal: true

require_relative 'sales_engine'
require_relative 'math_helper'
require_relative 'item_analyst'
require_relative 'invoice_analyst'
require_relative 'merchant_item_analyst'
require_relative 'merchant_invoice_analyst'
require 'bigdecimal'
require 'date'

class SalesAnalyst
  include MathHelper

  attr_reader :items,
              :merchants,
              :invoices,
              :invoice_items,
              :transactions,
              :sales_engine,
              :invoices_by_merchant,
              :transactions_by_invoice

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @items = sales_engine.items.items
    @merchants = sales_engine.merchants.merchants
    @invoices = sales_engine.invoices.invoices
    @invoice_items = sales_engine.invoice_items.invoice_items
    @transactions = sales_engine.transactions.transactions
    @invoices_by_merchant ||= group_invoices_by_merchant
    @transactions_by_invoice ||= group_transactions_by_invoice
  end

  def group_invoices_by_merchant
    @invoices.group_by(&:merchant_id)
  end

  def group_transactions_by_invoice
    @transactions.group_by(&:invoice_id)
  end

  def group_invoice_items_by_invoice_id
    @invoice_items.group_by(&:invoice_id)
  end

  def golden_items
    ItemAnalyst.new(@items).golden_items
  end

  def standard_deviation_for_items
    ItemAnalyst.new(@items).standard_deviation_for_items
  end

  def average_items_per_merchant
    MerchantItemAnalyst.new(
      @merchants, @items
    ).average_items_per_merchant
  end

  def average_average_price_per_merchant
    MerchantItemAnalyst.new(
      @merchants, @items
    ).average_average_price_per_merchant
  end

  def average_item_price_for_merchant(merchant_id)
    MerchantItemAnalyst.new(
      @merchants, @items
    ).average_item_price_for_merchant(merchant_id)
  end

  def merchants_with_high_item_count
    MerchantItemAnalyst.new(
      @merchants, @items
    ).merchants_with_high_item_count
  end

  def average_items_per_merchant_standard_deviation
    MerchantItemAnalyst.new(
      @merchants, @items
    ).average_items_per_merchant_standard_deviation
  end

  def merchants_with_only_one_item
    MerchantItemAnalyst.new(
      @merchants, @items, @sales_engine.merchants
    ).merchants_with_only_one_item
  end

  def merchants_with_only_one_item_registered_in_month(month)
    MerchantItemAnalyst.new(
      @merchants, @items, @sales_engine.merchants
    ).merchants_with_only_one_item_registered_in_month(month)
  end

  def average_invoices_per_merchant
    MerchantInvoiceAnalyst.new(
      @invoices_by_merchant, @merchants, @invoices
    ).average_invoices_per_merchant
  end

  def average_invoices_per_merchant_standard_deviation
    MerchantInvoiceAnalyst.new(
      @invoices_by_merchant, @merchants, @invoices
    ).average_invoices_per_merchant_standard_deviation
  end

  def bottom_merchants_by_invoice_count
    MerchantInvoiceAnalyst.new(
      @invoices_by_merchant, @merchants, @invoices
    ).bottom_merchants_by_invoice_count
  end

  def top_merchants_by_invoice_count
    MerchantInvoiceAnalyst.new(
      @invoices_by_merchant, @merchants, @invoices
    ).top_merchants_by_invoice_count
  end

  def top_days_by_invoice_count
    InvoiceAnalyst.new(@invoices).top_days_by_invoice_count
  end

  def invoice_status(status)
    InvoiceAnalyst.new(@invoices).invoice_status(status)
  end

  def find_invoice_items_by_invoice_date(date)
    InvoiceAnalyst.new(
      @invoices, @invoice_items
    ).find_invoice_items_by_invoice_date(date)
  end

  def total_revenue_by_date(date)
    InvoiceAnalyst.new(@invoices, @invoice_items).total_revenue_by_date(date)
  end

  def invoice_paid_in_full?(invoice_id)
    return false if @transactions_by_invoice[invoice_id].nil?
    @transactions_by_invoice[invoice_id].any? do |transaction|
      transaction.result == :success
    end
  end

  def invoice_total(invoice_id)
    if invoice_paid_in_full?(invoice_id)
      invoice_by_id = group_invoice_items_by_invoice_id
      total_price = invoice_by_id[invoice_id].inject(0) do |collector, invoice|
        collector + (invoice.quantity * invoice.unit_price)
      end
      BigDecimal(total_price, 5)
    end
  end

  def merchants_with_pending_invoices
    @invoices_by_merchant.each_with_object([]) do |(id, invoices), collector|
      invoices.each do |invoice|
        if invoice_paid_in_full?(invoice.id) == false
          collector << @sales_engine.merchants.find_by_id(id)
        end
      end
      collector
    end.uniq
  end

  def top_revenue_earners(top_merchants = 20)
    merchants = sort_merchants_by_revenue.map do |merchant_id, _revenue|
      @sales_engine.merchants.find_by_id(merchant_id)
    end
    merchants.reverse.slice(0..(top_merchants - 1))
  end

  def sort_merchants_by_revenue
    merchants_by_revenue.sort_by do |_merchant_id, revenue|
      revenue
    end.to_h
  end

  def merchants_ranked_by_revenue
    sort_merchants_by_revenue.map do |merchant_id, _revenue|
      @sales_engine.merchants.find_by_id(merchant_id)
    end.reverse
  end

  def merchants_by_revenue
    @invoices_by_merchant.each_with_object({}) do |(id, invoices), revenue|
      revenue[id] = invoices.inject(0) do |sum, invoice|
        if invoice_paid_in_full?(invoice.id)
          sum += invoice_total(invoice.id)
        else
          sum
        end
      end
      revenue
    end
  end

  def revenue_by_merchant(merchant_id)
    merchants_by_revenue[merchant_id]
  end

  def find_paid_invoices_per_merchant(id)
    @sales_engine.invoices.find_all_by_merchant_id(id).find_all do |invoice|
      invoice_paid_in_full?(invoice.id)
    end
  end

  def find_invoices_by_invoice_id(invoice_by_merchant)
    invoice_by_merchant.map do |invoice|
      @sales_engine.invoice_items.find_all_by_invoice_id(invoice.id)
    end.flatten
  end

  def find_item_quantities_sold_by_merchant(paid_invoice_items)
    paid_invoice_items.each_with_object(Hash.new(0)) do |invoice, sold|
      sold[invoice.item_id] += invoice.quantity
      sold
    end
  end

  def find_item_revenue_sold_by_merchant(paid_invoice_items)
    paid_invoice_items.each_with_object(Hash.new(0)) do |invoice, sold|
      sold[invoice.item_id] += invoice.quantity * invoice.unit_price
      sold
    end
  end

  def calculate_best_selling_item_by_merchant(merchant_items)
    merchant_items.each_with_object([]) do |(item, quantity), items|
      if quantity == merchant_items.values.max
        items << @sales_engine.items.find_by_id(item)
      end
      items
    end
  end

  def calculate_highest_revenue_item_by_merchant(revenue_by_item)
    revenue_by_item.max_by do |_item_id, revenue|
      revenue
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    invoice_by_merchant = find_paid_invoices_per_merchant(merchant_id)
    paid_invoice_items = find_invoices_by_invoice_id(invoice_by_merchant)
    merchant_items = find_item_quantities_sold_by_merchant(paid_invoice_items)
    calculate_best_selling_item_by_merchant(merchant_items)
  end

  def best_item_for_merchant(merchant_id)
    invoice_by_merchant = find_paid_invoices_per_merchant(merchant_id)
    paid_invoice_items = find_invoices_by_invoice_id(invoice_by_merchant)
    revenue_by_item = find_item_revenue_sold_by_merchant(paid_invoice_items)
    item_id = calculate_highest_revenue_item_by_merchant(revenue_by_item)
    @sales_engine.items.find_by_id(item_id[0])
  end
end
