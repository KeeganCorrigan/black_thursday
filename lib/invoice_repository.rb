require_relative 'sales_engine'
require_relative 'invoice'

class InvoiceRepository
  attr_reader :invoices

  def initialize(invoices)
    @invoices ||= create_invoice(invoices)
  end

  def create_invoice(invoices)
    invoices.map do |row|
      Invoice.new(row)
    end
  end

  def inspect
   "#<#{self.class} #{@invoices.size} rows>"
  end

  def all
    @invoices
  end

  def find_by_id(invoice_id)
    @invoices.find {|invoice| invoice.id == invoice_id}
  end

  def find_all_by_customer_id(customer_id)
    @invoices.find_all {|invoice| invoice.customer_id == customer_id}
  end

  def find_all_by_merchant_id(merchant_id)
    @invoices.find_all {|invoice| invoice.merchant_id == merchant_id}
  end

  def find_all_by_status(status)
    @invoices.find_all {|invoice| invoice.status == status}
  end

  def generate_id_for_new_invoice
    (@invoices.max_by { |invoice| invoice.id }).id + 1
  end

  def create(attributes)
    attributes[:id] = generate_id_for_new_invoice
    @invoices << Invoice.new(attributes)
  end

  def update(id, attributes)
    return if attributes.empty?
    invoice_to_update = find_by_id(id)
    invoice_to_update.status = attributes[:status]
    invoice_to_update.updated_at = Time.now
  end

  def delete(id)
    invoice_to_delete = find_by_id(id)
    @invoices.delete(invoice_to_delete)
  end
end
