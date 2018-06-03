require 'bigdecimal'
require_relative 'invoice_item_repository'
require_relative 'data_helper'

class InvoiceItem
  include DataHelper

  attr_accessor :quantity,
                :unit_price,
                :updated_at

    attr_reader :id,
                :item_id,
                :invoice_id,
                :merchant_id,
                :created_at

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
end
