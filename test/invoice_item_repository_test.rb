# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/invoice_item_repository'
require 'pry'

class InvoiceItemRepositoryTest < Minitest::Test
  def setup
    @attributes =
      {
        item_id: 7,
        invoice_id: 8,
        quantity: 1,
        unit_price: BigDecimal(10.99, 4),
        created_at: Time.now,
        updated_at: Time.now
      }
    invoice_items =
      [
        { id: 1,
          item_id: 1,
          invoice_id: 1,
          quantity: 5,
          unit_price: 136_35,
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 2,
          item_id: 2,
          invoice_id: 2,
          quantity: 9,
          unit_price: 233_24,
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 3,
          item_id: 3,
          invoice_id: 3,
          quantity: 8,
          unit_price: 348_73,
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 4,
          item_id: 4,
          invoice_id: 4,
          quantity: 3,
          unit_price: 2196,
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 5,
          item_id: 5,
          invoice_id: 5,
          quantity: 7,
          unit_price: 791_40,
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 6,
          item_id: 6,
          invoice_id: 6,
          quantity: 5,
          unit_price: 521_00,
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 7,
          item_id: 7,
          invoice_id: 7,
          quantity: 4,
          unit_price: 667_47,
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 8,
          item_id: 8,
          invoice_id: 8,
          quantity: 6,
          unit_price: 769_41,
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 9,
          item_id: 9,
          invoice_id: 9,
          quantity: 6,
          unit_price: 299_73,
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 10,
          item_id: 10,
          invoice_id: 10,
          quantity: 4,
          unit_price: 1859,
          created_at: '2012-03-27',
          updated_at: '2012-03-27' }
      ]

    @ii = InvoiceItemRepository.new(invoice_items)
  end

  def test_it_exists
    assert_instance_of(InvoiceItemRepository, @ii)
  end

  def test_returns_all
    assert_equal 10, @ii.all.length
  end

  def test_find_by_id
    id = 10
    expected = @ii.find_by_id(id)
    assert_equal 10, expected.item_id
    assert_equal 10, expected.invoice_id
  end

  def test_find_all_by_item_id
    item_id = 1
    expected = @ii.find_all_by_item_id(item_id)
    assert_equal 1, expected.length
    assert_equal InvoiceItem, expected.first.class
  end

  def test_find_all_by_invoice_id
    invoice_id = 1
    expected = @ii.find_all_by_invoice_id(invoice_id)
    assert_equal 1, expected.length
    assert_equal InvoiceItem, expected.first.class
  end

  def test_create
    @ii.create(@attributes)
    expected = @ii.find_by_id(11)
    assert_equal 7, expected.item_id
  end

  def test_update
    @ii.create(@attributes)
    original_time = @ii.find_by_id(11).updated_at
      attributes = {
        quantity: 13
      }
    @ii.update(11, attributes)
    expected = @ii.find_by_id(11)
    assert_equal 13, expected.quantity
    assert_equal 7, expected.item_id
    assert expected.updated_at > original_time
  end

  def test_delete
    @ii.create(@attributes)
    @ii.delete(11)
    assert_nil @ii.find_by_id(11)
  end
end
