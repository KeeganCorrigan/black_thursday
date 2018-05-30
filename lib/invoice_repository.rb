require_relative 'sales_engine'
require_relative 'repository_helper'
require_relative 'invoice'

class InvoiceRepository < RepositoryHelper
  attr_reader :invoices,
              :table

  def initialize(invoices)
    @table ||= create_invoice(invoices)
    @invoices = @table
  end

  def create_invoice(invoices)
    invoices.map do |row|
      Invoice.new(row)
    end
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
  
  def create(attributes)
    attributes[:id] = generate_new_id
    @invoices << Invoice.new(attributes)
  end

  def update(id, attributes)
    return if attributes.empty?
    invoice_to_update = find_by_id(id)
    invoice_to_update.status = attributes[:status]
    invoice_to_update.updated_at = Time.now
  end
end
