# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test
  def setup
    @attributes =
      {
        customer_id: 7,
        merchant_id: 8,
        status: :pending,
        created_at: Time.now,
        updated_at: Time.now
      }

    invoices =
      [
        { id: 1,
          customer_id: 1,
          merchant_id: 1,
          status: :pending,
          created_at: '2012-10-07',
          updated_at: '2014-03-15' },
        { id: 2,
          customer_id: 1,
          merchant_id: 1,
          status: :shipped,
          created_at: '2012-11-23',
          updated_at: '2013-04-14' },
        { id: 3,
          customer_id: 1,
          merchant_id: 2,
          status: :shipped,
          created_at: '2009-12-09',
          updated_at: '2010-07-10' },
        { id: 4,
          customer_id: 3,
          merchant_id: 2,
          status: :pending,
          created_at: '2013-08-05',
          updated_at: '2014-06-06' },
        { id: 5,
          customer_id: 3,
          merchant_id: 2,
          status: :pending,
          created_at: '2009-05-08',
          updated_at: '2014-07-22' },
        { id: 6,
          customer_id: 2,
          merchant_id: 3,
          status: :pending,
          created_at: '2015-03-13',
          updated_at: '2015-04-05' },
        { id: 7,
          customer_id: 2,
          merchant_id: 3,
          status: :pending,
          created_at: '2006-10-16',
          updated_at: '2013-12-24' },
        { id: 8,
          customer_id: 4,
          merchant_id: 3,
          status: :shipped,
          created_at: '2003-11-07',
          updated_at: '2004-07-31' },
        { id: 9,
          customer_id: 4,
          merchant_id: 4,
          status: :shipped,
          created_at: '2003-03-07',
          updated_at: '2008-10-09' },
        { id: 10,
          customer_id: 2,
          merchant_id: 4,
          status: :pending,
          created_at: '2014-04-13',
          updated_at: '2015-01-20' }
      ]

    @ii = InvoiceRepository.new(invoices)
  end

  def test_it_exists
    assert_instance_of(InvoiceRepository, @ii)
  end

  def test_it_creates_items_list
    assert_equal 1, @ii.invoices[0].id
    assert_equal 10, @ii.invoices.length
  end

  def test_all
    assert_equal 10, @ii.all.length
  end

  def test_find_by_id
    invoice_id = 1
    expected = @ii.find_by_id(invoice_id)
    assert_equal invoice_id, expected.id
    assert_equal 1, expected.merchant_id
    assert_equal 1, expected.customer_id
    assert_equal :pending, expected.status

    invoice_id = 5000
    expected = @ii.find_by_id(invoice_id)
    assert_nil expected
  end

  def test_find_all_by_customer_id
    customer_id = 1
    expected = @ii.find_all_by_customer_id(customer_id)
    assert_equal 3, expected.length
    customer_id = 1000
    expected = @ii.find_all_by_customer_id(customer_id)
    assert_equal [], expected
  end

  def test_find_all_by_merchant_id
    merchant_id = 1
    expected = @ii.find_all_by_merchant_id(merchant_id)
    assert_equal 2, expected.length
    merchant_id = 90
    expected = @ii.find_all_by_merchant_id(merchant_id)
    assert_equal [], expected
  end

  def test_find_all_by_status
    status = :shipped
    expected = @ii.find_all_by_status(status)
    assert_equal 4, expected.length
    status = :pending
    expected = @ii.find_all_by_status(status)
    assert_equal 6, expected.length
    status = :sold
    expected = @ii.find_all_by_status(status)
    assert_equal [], expected
  end

  def test_it_generates_invoice_id
    expected = @ii.generate_new_id
    assert_equal 11, expected
  end

  def test_it_creates_new_invoice
    @ii.create(@attributes)
    expected = @ii.find_by_id(11)
    assert_equal 8, expected.merchant_id
  end

  def test_it_updates
    @ii.create(@attributes)
    info = {
      status: :success
    }
    new_invoice = @ii.find_by_id(11)
    original_time = new_invoice.updated_at
    @ii.update(11, info)
    assert_equal :success, new_invoice.status
    assert_equal 7, new_invoice.customer_id
    assert new_invoice.updated_at > original_time
  end

  def test_it_deletes
    @ii.delete(9)
    expected = @ii.find_by_id(9)
    assert_nil expected
  end
end
