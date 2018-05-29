require_relative 'sales_engine'
require_relative 'invoice_item'

class InvoiceItemRepository
  attr_reader :invoice_items

  def initialize(invoice_items)
    @invoice_items ||= create_invoice_item(invoice_items)
  end

  def create_invoice_item(invoice_items)
    invoice_items.map do |row|
      InvoiceItem.new(row)
    end
  end

  def inspect
   "#<#{self.class} #{@invoice_items.size} rows>"
  end

  def all
    @invoice_items
  end

  def find_by_id(id)
    @invoice_items.find {|invoice_item| invoice_item.id == id}
  end

  def find_all_by_item_id(item_id)
    @invoice_items.find_all {|invoice_item| invoice_item.item_id == item_id}
  end

  def find_all_by_invoice_id(invoice_id)
    @invoice_items.find_all {|invoice_item| invoice_item.invoice_id == invoice_id}
  end

  def create(attributes)
    attributes[:id] = generate_id_for_new_invoice_item
    @invoice_items << InvoiceItem.new(attributes)
  end

  def generate_id_for_new_invoice_item
    (@invoice_items.max_by { |invoice_item| invoice_item.id }).id + 1
  end

  def update(id, attributes)
    return if attributes.empty?
    invoice_item_to_update = find_by_id(id)
    invoice_item_to_update.quantity = attributes[:quantity]
    invoice_item_to_update.unit_price = attributes[:unit_price]
    invoice_item_to_update.updated_at = Time.now
  end

  def delete(id)
    invoice_item_to_delete = find_by_id(id)
    @invoice_items.delete(invoice_item_to_delete)
  end
end
