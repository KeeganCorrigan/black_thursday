require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/invoice_item_repository'
require 'bigdecimal'
require 'pry'

class InvoiceItemRepositoryTest < Minitest::Test
  def setup
    @attributes = {
                  :item_id => 7,
                  :invoice_id => 8,
                  :quantity => 1,
                  :unit_price => BigDecimal.new(10.99, 4),
                  :created_at => Time.now,
                  :updated_at => Time.now
                }
    invoice_item_info = {:invoice_items => "./data/invoice_items.csv"}
    se = SalesEngine.from_csv(invoice_item_info)
    @ii = se.invoice_items
  end

  def test_it_exists
    assert_instance_of(InvoiceItemRepository, @ii)
  end

  def test_returns_all
    assert_equal 21830, @ii.all.length
  end

  def test_find_by_id
    id = 10
    expected = @ii.find_by_id(id)
    assert_equal 263523644, expected.item_id
    assert_equal 2, expected.invoice_id
  end

  def test_find_all_by_item_id
    item_id = 263408101
    expected = @ii.find_all_by_item_id(item_id)
    assert_equal 11, expected.length
    assert_equal InvoiceItem, expected.first.class
  end

  def test_find_all_by_invoice_id
    invoice_id = 100
    expected = @ii.find_all_by_invoice_id(invoice_id)
    assert_equal 3, expected.length
    assert_equal InvoiceItem, expected.first.class
  end

  def test_create
    @ii.create(@attributes)
    expected = @ii.find_by_id(21831)
    assert_equal 7, expected.item_id
  end

  def test_update
    @ii.create(@attributes)
    original_time = @ii.find_by_id(21831).updated_at
      attributes = {
        quantity: 13
      }
    @ii.update(21831, attributes)
    expected = @ii.find_by_id(21831)
    assert_equal 13, expected.quantity
    assert_equal 7, expected.item_id
    assert expected.updated_at > original_time
  end

  def test_delete
    @ii.create(@attributes)
    @ii.delete(21831)
    assert_nil @ii.find_by_id(21831)
  end
end
