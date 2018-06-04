# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/invoice_repository'

class InvoiceTest < Minitest::Test
  def setup
    information =
      {
        id: 1,
        customer_id: 1,
        merchant_id: 12335938,
        status: 'pending',
        created_at: '2009-02-07',
        updated_at: '2014-03-15'
      }
    @invoice = Invoice.new(information)
  end

  def test_it_exists
    assert_instance_of(Invoice, @invoice)
  end

  def test_it_has_attributes
    assert_equal 1, @invoice.id
    assert_equal 1, @invoice.customer_id
    assert_equal 12335938, @invoice.merchant_id
    assert_equal :pending, @invoice.status
    assert_equal Time, @invoice.created_at.class
    assert_equal Time, @invoice.updated_at.class
  end
end
