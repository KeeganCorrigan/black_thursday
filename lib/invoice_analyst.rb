require_relative 'sales_analyst'
require 'date'

class InvoiceAnalyst
  attr_reader :invoices

  def initialize(invoices)
    @invoices = invoices
  end

  def invoices_created_by_day
    @invoices.map {|invoice| invoice.created_at.wday}
  end

  def count_invoices_created_by_day
    invoices_created_by_day.each_with_object(Hash.new(0)) {|day,invoice_id| invoice_id[day] += 1}
  end

  def top_days_by_invoice_count
    [Date::DAYNAMES[count_invoices_created_by_day.max_by {|day, value| value}.first]]
  end

  def invoice_status(status)
    BigDecimal.new(((@invoices.find_all { |invoice| invoice.status == status}.count).to_f / (total_invoices = @invoices.length).to_f) * 100, 4)
  end
end
