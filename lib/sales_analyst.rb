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

  def invoice_paid_in_full?(invoice_id)
    return false if @transactions_by_invoice[invoice_id].nil?
    @transactions_by_invoice[invoice_id].any? {|transaction| transaction.result == :success}
  end

  def group_invoices_by_merchant
    @invoices.group_by {|invoice| invoice.merchant_id}
  end

  def group_transactions_by_invoice
    @transactions.group_by {|transaction| transaction.invoice_id}
  end

  def group_invoice_items_by_invoice_id
    @invoice_items.group_by {|invoice_item| invoice_item.invoice_id}
  end

  def golden_items
    ItemAnalyst.new(@items).golden_items
  end

  def standard_deviation_for_items
    ItemAnalyst.new(@items).standard_deviation_for_items
  end

  def average_items_per_merchant
    MerchantItemAnalyst.new(@merchants, @items).average_items_per_merchant
  end

  def average_average_price_per_merchant
    MerchantItemAnalyst.new(@merchants, @items).average_average_price_per_merchant
  end

  def average_item_price_for_merchant(merchant_id)
    MerchantItemAnalyst.new(@merchants, @items).average_item_price_for_merchant(merchant_id)
  end

  def merchants_with_high_item_count
    MerchantItemAnalyst.new(@merchants, @items).merchants_with_high_item_count
  end

  def average_items_per_merchant_standard_deviation
    MerchantItemAnalyst.new(@merchants, @items).average_items_per_merchant_standard_deviation
  end

  def merchants_with_only_one_item
    MerchantItemAnalyst.new(@merchants, @items, @sales_engine.merchants).merchants_with_only_one_item
  end

  def merchants_with_only_one_item_registered_in_month(month)
    MerchantItemAnalyst.new(@merchants, @items, @sales_engine.merchants).merchants_with_only_one_item_registered_in_month(month)
  end

  def average_invoices_per_merchant
    MerchantInvoiceAnalyst.new(@invoices_by_merchant, @merchants, @invoices).average_invoices_per_merchant
  end

  def average_invoices_per_merchant_standard_deviation
    MerchantInvoiceAnalyst.new(@invoices_by_merchant, @merchants, @invoices).average_invoices_per_merchant_standard_deviation
  end

  def bottom_merchants_by_invoice_count
    MerchantInvoiceAnalyst.new(@invoices_by_merchant, @merchants, @invoices).bottom_merchants_by_invoice_count
  end

  def top_merchants_by_invoice_count
    MerchantInvoiceAnalyst.new(@invoices_by_merchant, @merchants, @invoices).top_merchants_by_invoice_count
  end

  def top_days_by_invoice_count
    InvoiceAnalyst.new(@invoices).top_days_by_invoice_count
  end

  def invoice_status(status)
    InvoiceAnalyst.new(@invoices).invoice_status(status)
  end

  def find_invoice_items_by_invoice_date(date)
    InvoiceAnalyst.new(@invoices, @invoice_items).find_invoice_items_by_invoice_date(date)
  end

  def total_revenue_by_date(date)
    InvoiceAnalyst.new(@invoices, @invoice_items).total_revenue_by_date(date)
  end

  def invoice_total(invoice_id)
    if invoice_paid_in_full?(invoice_id)
      BigDecimal.new(group_invoice_items_by_invoice_id[invoice_id].inject(0) {|collector, invoice| collector += (invoice.quantity * invoice.unit_price)}, 5)
    end
  end

  def merchants_with_pending_invoices
    @invoices_by_merchant.inject([]) do |collector, (merchant_id, invoices)|
      invoices.each do |invoice|
        if invoice_paid_in_full?(invoice.id) == false
          collector << @sales_engine.merchants.find_by_id(merchant_id)
        end
      end
      collector
    end.uniq
  end

  def top_revenue_earners(top_merchants = 20)
    top_merchants_sorted = sort_merchants_by_revenue.map do |merchant_id, _revenue|
      @sales_engine.merchants.find_by_id(merchant_id)
    end
    top_merchants_sorted.reverse.slice(0..(top_merchants - 1))
  end

  def sort_merchants_by_revenue
    merchants_by_revenue.sort_by {|_merchant_id, revenue| revenue}.to_h
  end

  def merchants_ranked_by_revenue
    sort_merchants_by_revenue.map do |merchant_id, _revenue|
      @sales_engine.merchants.find_by_id(merchant_id)
    end.reverse
  end

  def merchants_by_revenue
    @invoices_by_merchant.inject({}) do |revenue_by_merchant, (merchant_id, invoices)|
      revenue_by_merchant[merchant_id] = invoices.inject(0) do |sum, invoice|
        if invoice_paid_in_full?(invoice.id) == false
          sum += 0
        else
          sum += invoice_total(invoice.id)
        end
      end
      revenue_by_merchant
    end
  end

  def revenue_by_merchant(merchant_id)
    merchants_by_revenue[merchant_id]
  end

  def calculate_quantity_sold_from_item_id(item_id)
    @sales_engine.invoice_items.find_all_by_item_id(item_id).inject({}) do |collector, invoice_item|
      if invoice_paid_in_full?(invoice_item.invoice_id)
        if collector[item_id] != nil
          collector[item_id] += invoice_item.quantity
        else
          collector[item_id] = invoice_item.quantity
        end
      end
      collector
    end
  end

  def calculate_total_amount_of_revenue_from_item(item_id)
    @sales_engine.invoice_items.find_all_by_item_id(item_id).inject({}) do |collector, invoice_item|
      if invoice_paid_in_full?(invoice_item.invoice_id)
        if collector[item_id] != nil
          collector[item_id] += (invoice_item.quantity * invoice_item.unit_price)
        else
          collector[item_id] = (invoice_item.quantity * invoice_item.unit_price)
        end
      end
      collector
    end
  end

  def items_sold_by_merchant_by_revenue(merchant_id)
    @sales_engine.items.find_all_by_merchant_id(merchant_id).inject([]) do |collector, item|
      collector << calculate_total_amount_of_revenue_from_item(item.id)
    end.inject({}, :merge)
  end

  def items_sold_by_merchant_by_quantity(merchant_id)
    @sales_engine.items.find_all_by_merchant_id(merchant_id).inject([]) do |collector, item|
      collector << calculate_quantity_sold_from_item_id(item.id)
    end.inject({}, :merge)
  end

  def find_highest_values_of_items_sold_by_merchant(item_quantities)
    item_quantities.inject([]) do |collector, (item, quantity)|
      collector << @sales_engine.items.find_by_id(item) if quantity == item_quantities.values.max
      collector
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    find_highest_values_of_items_sold_by_merchant(items_sold_by_merchant_by_quantity(merchant_id))
  end

  def best_item_for_merchant(merchant_id)
    find_highest_values_of_items_sold_by_merchant(items_sold_by_merchant_by_revenue(merchant_id))[0]
  end
end
