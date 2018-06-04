# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/invoice_analyst'
require './lib/invoice_item'
require './lib/invoice'
require 'pry'

class InvoiceAnalystTest < Minitest::Test
  def setup
    invoices =
      [
        Invoice.new(id: 1,
                    customer_id: 1,
                    merchant_id: 1,
                    status: :pending,
                    created_at: '2012-10-07',
                    updated_at: '2014-03-15'),
        Invoice.new(id: 2,
                    customer_id: 1,
                    merchant_id: 1,
                    status: :shipped,
                    created_at: '2012-11-23',
                    updated_at: '2013-04-14'),
        Invoice.new(id: 3,
                    customer_id: 1,
                    merchant_id: 2,
                    status: :shipped,
                    created_at: '2009-12-09',
                    updated_at: '2010-07-10'),
        Invoice.new(id: 4,
                    customer_id: 3,
                    merchant_id: 2,
                    status: :pending,
                    created_at: '2013-08-05',
                    updated_at: '2014-06-06'),
        Invoice.new(id: 5,
                    customer_id: 3,
                    merchant_id: 2,
                    status: :pending,
                    created_at: '2009-05-08',
                    updated_at: '2014-07-22'),
        Invoice.new(id: 6,
                    customer_id: 2,
                    merchant_id: 3,
                    status: :pending,
                    created_at: '2015-03-13',
                    updated_at: '2015-04-05'),
        Invoice.new(id: 7,
                    customer_id: 2,
                    merchant_id: 3,
                    status: :pending,
                    created_at: '2006-10-16',
                    updated_at: '2013-12-24'),
        Invoice.new(id: 8,
                    customer_id: 4,
                    merchant_id: 3,
                    status: :shipped,
                    created_at: '2003-11-07',
                    updated_at: '2004-07-31'),
        Invoice.new(id: 9,
                    customer_id: 4,
                    merchant_id: 4,
                    status: :shipped,
                    created_at: '2003-03-07',
                    updated_at: '2008-10-09'),

        Invoice.new(id: 10,
                    customer_id: 2,
                    merchant_id: 4,
                    status: :pending,
                    created_at: '2014-04-13',
                    updated_at: '2015-01-20')
      ]

    invoice_items =
      [
        InvoiceItem.new(id: 1,
                        item_id: 1,
                        invoice_id: 1,
                        quantity: 5,
                        unit_price: 136_35,
                        created_at: '2012-03-27',
                        updated_at: '2012-03-27'),
         InvoiceItem.new(id: 2,
                         item_id: 2,
                         invoice_id: 2,
                         quantity: 9,
                         unit_price: 233_24,
                         created_at: '2012-03-27',
                         updated_at: '2012-03-27'),
         InvoiceItem.new(id: 3,
                         item_id: 3,
                         invoice_id: 3,
                         quantity: 8,
                         unit_price: 348_73,
                         created_at: '2012-03-27',
                         updated_at: '2012-03-27'),
         InvoiceItem.new(id: 4,
                         item_id: 4,
                         invoice_id: 4,
                         quantity: 3,
                         unit_price: 2196,
                         created_at: '2012-03-27',
                         updated_at: '2012-03-27'),
         InvoiceItem.new(id: 5,
                         item_id: 5,
                         invoice_id: 5,
                         quantity: 7,
                         unit_price: 791_40,
                         created_at: '2012-03-27',
                         updated_at: '2012-03-27'),
         InvoiceItem.new(id: 6,
                         item_id: 6,
                         invoice_id: 6,
                         quantity: 5,
                         unit_price: 521_00,
                         created_at: '2012-03-27',
                         updated_at: '2012-03-27'),
         InvoiceItem.new(id: 7,
                         item_id: 7,
                         invoice_id: 7,
                         quantity: 4,
                         unit_price: 667_47,
                         created_at: '2012-03-27',
                         updated_at: '2012-03-27'),
         InvoiceItem.new(id: 8,
                         item_id: 8,
                         invoice_id: 8,
                         quantity: 6,
                         unit_price: 769_41,
                         created_at: '2012-03-27',
                         updated_at: '2012-03-27'),
         InvoiceItem.new(id: 9,
                         item_id: 9,
                         invoice_id: 9,
                         quantity: 6,
                         unit_price: 299_73,
                         created_at: '2012-03-27',
                         updated_at: '2012-03-27'),
         InvoiceItem.new(id: 10,
                         item_id: 10,
                         invoice_id: 10,
                         quantity: 4,
                         unit_price: 1859,
                         created_at: '2012-03-27',
                         updated_at: '2012-03-27')
      ]

    @ia = InvoiceAnalyst.new(invoices, invoice_items)
  end

  def test_it_has_attributes
    assert_equal 10, @ia.invoices.length
  end

  def test_invoices_created_by_day
    expected = @ia.invoices_created_by_day
    assert_equal Array, expected.class
    assert_equal 10, expected.length
  end

  def test_count_invoices_created_by_day
    expected = @ia.count_invoices_created_by_day
    assert_equal Hash, expected.class
    assert_equal 4, expected.length
  end

  def test_group_invoices_by_date
    expected = @ia.group_invoices_by_date
    assert_equal 10, expected.length
    assert_equal Array, expected[Time.parse('2012-10-07')].class
  end
end
