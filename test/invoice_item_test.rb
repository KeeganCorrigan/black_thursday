require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/invoice_item_repository'
require 'time'
require 'bigdecimal'
require 'pry'

class InvoiceItemTest < Minitest::Test
  def setup
    @information = {
          :id => 1,
          :item_id => 263519844,
          :invoice_id => 1,
          :quantity => 5,
          :unit_price => 13635,
          :created_at  => Time.now,
          :updated_at  => Time.now,
        }
  end

  def test_it_exists
    invoice_item = InvoiceItem.new(@information)
    assert_instance_of(InvoiceItem, invoice_item)
  end

  def test_it_has_attributes
    invoice_item = InvoiceItem.new(@information)
    assert_equal 1, invoice_item.id
    assert_equal 263519844, invoice_item.item_id
    assert_equal 1, invoice_item.invoice_id
    assert_equal 5, invoice_item.quantity
    assert_equal 136.35, invoice_item.unit_price
    assert_equal Time, invoice_item.created_at.class
    assert_equal Time, invoice_item.updated_at.class
  end
end
