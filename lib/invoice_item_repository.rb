require_relative 'sales_engine'
require_relative 'invoice_item'
require_relative 'repository_helper'

class InvoiceItemRepository < RepositoryHelper
  attr_reader :invoice_items,
              :table

  def initialize(invoice_items)
    @table ||= create_invoice_item(invoice_items)
    @invoice_items = @table
  end

  def create_invoice_item(invoice_items)
    invoice_items.map do |row|
      InvoiceItem.new(row)
    end
  end

  def find_all_by_item_id(item_id)
    @invoice_items.find_all {|invoice_item| invoice_item.item_id == item_id}
  end

  def find_all_by_invoice_id(invoice_id)
    @invoice_items.find_all {|invoice_item| invoice_item.invoice_id == invoice_id}
  end

  def create(attributes)
    attributes[:id] = generate_new_id
    @invoice_items << InvoiceItem.new(attributes)
  end

  def update(id, attributes)
    return if attributes.empty?
    invoice_item_to_update = find_by_id(id)
    invoice_item_to_update.quantity = attributes[:quantity]
    invoice_item_to_update.unit_price = attributes[:unit_price]
    invoice_item_to_update.updated_at = Time.now
  end
end
