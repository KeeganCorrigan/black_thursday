# frozen_string_literal: true

require_relative 'sales_analyst'
require 'date'

class InvoiceAnalyst
  attr_reader :invoices,
              :invoice_items

  def initialize(invoices, invoice_items = nil)
    @invoices = invoices
    @invoice_items = invoice_items
  end

  def invoices_created_by_day
    @invoices.map { |invoice| invoice.created_at.wday }
  end

  def count_invoices_created_by_day
    invoices_created_by_day.each_with_object(Hash.new(0)) do |day, invoice_id|
      invoice_id[day] += 1
    end
  end

  def top_days_by_invoice_count
    [Date::DAYNAMES[count_invoices_created_by_day.max_by do |_day, value|
      value
    end.first]]
  end

  def invoice_status(status)
    invoice_total = @invoices.find_all do |invoice|
      invoice.status == status
    end.count.to_f
    BigDecimal((invoice_total / @invoices.length.to_f * 100), 4)
  end

  def group_invoices_by_date
    @invoices.group_by(&:created_at)
  end

  def find_invoice_items_by_invoice_date(date)
    group_invoices_by_date[date].each_with_object([]) do |invoice, dates|
      dates << invoice.id
      dates
    end
  end

  def total_revenue_by_date(date)
    invoices_by_date = find_invoice_items_by_invoice_date(date)
    @invoice_items.inject(0) do |sum, invoice_item|
      if invoices_by_date.include?(invoice_item.invoice_id)
        sum += (invoice_item.unit_price * invoice_item.quantity)
      end
      sum
    end
  end
end
