# frozen_string_literal: true

require_relative 'sales_engine'
require_relative 'math_helper'
require_relative 'item_analyst'
require_relative 'invoice_analyst'
require_relative 'merchant_item_analyst'
require_relative 'merchant_invoice_analyst'
require_relative 'revenue_analyst'
require 'bigdecimal'
require 'date'

class SalesAnalyst
  include MathHelper

  attr_reader :items,
              :merchants,
              :invoices,
              :invoice_items,
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
    RevenueAnalyst.new(
      @sales_engine, @invoices_by_merchant, @transactions_by_invoice
    ).invoice_paid_in_full?(invoice_id)
  end

  def invoice_total(invoice_id)
    RevenueAnalyst.new(
      @sales_engine, @invoices_by_merchant, @transactions_by_invoice
    ).invoice_total(invoice_id)
  end

  def merchants_with_pending_invoices
    RevenueAnalyst.new(
      @sales_engine, @invoices_by_merchant, @transactions_by_invoice
    ).merchants_with_pending_invoices
  end

  def top_revenue_earners(top_merchants = 20)
    RevenueAnalyst.new(
      @sales_engine, @invoices_by_merchant, @transactions_by_invoice
    ).top_revenue_earners(top_merchants)
  end

  def merchants_ranked_by_revenue
    RevenueAnalyst.new(
      @sales_engine, @invoices_by_merchant, @transactions_by_invoice
    ).merchants_ranked_by_revenue
  end

  def revenue_by_merchant(merchant_id)
    RevenueAnalyst.new(
      @sales_engine, @invoices_by_merchant, @transactions_by_invoice
    ).revenue_by_merchant(merchant_id)
  end

  def most_sold_item_for_merchant(merchant_id)
    RevenueAnalyst.new(
      @sales_engine, @invoices_by_merchant, @transactions_by_invoice
    ).most_sold_item_for_merchant(merchant_id)
  end

  def best_item_for_merchant(merchant_id)
    RevenueAnalyst.new(
      @sales_engine, @invoices_by_merchant, @transactions_by_invoice
    ).best_item_for_merchant(merchant_id)
  end
end
