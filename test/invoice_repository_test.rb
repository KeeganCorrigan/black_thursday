require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/invoice_repository'
require 'bigdecimal'
require 'pry'

class InvoiceRepositoryTest < Minitest::Test
  def setup
    @attributes = {
          :customer_id => 7,
          :merchant_id => 8,
          :status      => "pending",
          :created_at  => Time.now,
          :updated_at  => Time.now,
        }
    invoice_info = {:invoices => "./data/invoices.csv"}
    se = SalesEngine.from_csv(invoice_info)
    @ii = se.invoices
  end

  def test_it_exists
    assert_instance_of(InvoiceRepository, @ii)
  end

  def test_it_creates_items_list
    assert_equal 1, @ii.invoices[0].id
    assert_equal 4985, @ii.invoices.length
  end

  def test_all
    assert_equal 4985, @ii.all.length
  end

  def test_find_by_id
    invoice_id = 3452
    expected = @ii.find_by_id(invoice_id)
    assert_equal invoice_id, expected.id
    assert_equal 12335690, expected.merchant_id
    assert_equal 679, expected.customer_id
    assert_equal :pending, expected.status

    invoice_id = 5000
    expected = @ii.find_by_id(invoice_id)
    assert_nil expected
  end

  def test_find_all_by_customer_id
    customer_id = 300
    expected = @ii.find_all_by_customer_id(customer_id)
    assert_equal 10, expected.length
    customer_id = 1000
    expected = @ii.find_all_by_customer_id(customer_id)
    assert_equal [], expected
  end

  def test_find_all_by_merchant_id
    merchant_id = 12335080
    expected = @ii.find_all_by_merchant_id(merchant_id)
    assert_equal 7, expected.length
    merchant_id = 1000
    expected = @ii.find_all_by_merchant_id(merchant_id)
    assert_equal [], expected
  end

  def test_find_all_by_status
    status = :shipped
    expected = @ii.find_all_by_status(status)
    assert_equal 2839, expected.length
    status = :pending
    expected = @ii.find_all_by_status(status)
    assert_equal 1473, expected.length
    status = :sold
    expected = @ii.find_all_by_status(status)
    assert_equal [], expected
  end

  def test_it_generates_invoice_id
    expected = @ii.generate_id_for_new_invoice
    assert_equal 4986, expected
  end

  def test_it_creates_new_invoice
    @ii.create(@attributes)
    expected = @ii.find_by_id(4986)
    assert_equal 8, expected.merchant_id
  end

  def test_it_updates
    @ii.create(@attributes)
    info = {
      status: :success
    }
    new_invoice = @ii.find_by_id(4986)
    original_time = new_invoice.updated_at
    @ii.update(4986, info)
    assert_equal :success, new_invoice.status
    assert_equal 7, new_invoice.customer_id
    assert new_invoice.updated_at > original_time
  end

  def test_it_deletes
    @ii.delete(4986)
    expected = @ii.find_by_id(4986)
    assert_nil expected
  end
end
