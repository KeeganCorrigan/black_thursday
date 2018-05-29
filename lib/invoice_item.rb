require 'bigdecimal'
require 'time'
require_relative 'invoice_item_repository'

class InvoiceItem
  attr_accessor :quantity, :unit_price, :updated_at

  attr_reader :id, :item_id, :invoice_id, :merchant_id, :created_at

  def initialize(information)
    @id = information[:id]
    @item_id = information[:item_id]
    @invoice_id = information[:invoice_id]
    @quantity = information[:quantity]
    @unit_price = (BigDecimal.new(information[:unit_price])) / 100
    @merchant_id = information[:merchant_id]
    @created_at = convert_time(information[:created_at])
    @updated_at = convert_time(information[:updated_at])
  end

  def convert_time(time)
    if time.class == String
      Time.parse(time)
    else
      return time
    end
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end
end
