require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/transaction_repository'
require 'bigdecimal'

class TransactionRepositoryTest < Minitest::Test
  def setup
    transaction_info = {:transactions => "./data/transactions.csv"}
    se = SalesEngine.from_csv(transaction_info)
    @t = se.transactions
    @attributes = {
        :invoice_id => 8,
        :credit_card_number => "4242424242424242",
        :credit_card_expiration_date => "0220",
        :result => "success",
        :created_at => Time.now,
        :updated_at => Time.now
      }
  end

  def test_it_exists
    assert_instance_of(TransactionRepository, @t)
  end

  def test_all
    assert_equal 4985, @t.all.length
  end

  def test_find_by_id
    expected = @t.find_by_id(8)
    assert_equal "4839506591130477", expected.credit_card_number
    assert_equal Transaction, expected.class
  end

  def test_find_all_by_invoice_id
    expected = @t.find_all_by_invoice_id(2179)
    assert_equal 2, expected.length
    assert_equal Transaction, expected.first.class
  end

  def test_find_all_by_credit_card_number
    expected = @t.find_all_by_credit_card_number("4848466917766329")
    assert_equal 1, expected.length
    assert_equal Transaction, expected.first.class
    credit_card_number = "4848466917766328"
    expected = @t.find_all_by_credit_card_number("4848466917766328")
    assert expected.empty?
  end

  def find_all_by_result
    expected = @t.find_all_by_result(:success)
    assert_equal 4158, expected.length
  end

  def test_generate_id_for_new_transaction
    expected = @t.generate_id_for_new_transaction
    assert_equal 4986, expected
  end

  def test_create
    created = @t.create(@attributes)
    expected = @t.find_by_id(4986)
    assert_equal "4242424242424242", expected.credit_card_number
  end

  def test_update
    created = @t.create(@attributes)
    original_time = @t.find_by_id(4986).updated_at
    attributes = {
      result: :failed
    }
    @t.update(4986, attributes)
    expected = @t.find_by_id(4986)
    assert_equal :failed, expected.result
    assert_equal "0220", expected.credit_card_expiration_date
    assert expected.updated_at > original_time
    original_time = @t.find_by_id(9).updated_at
    information = {
        :credit_card_number => "4242424242424242",
        :credit_card_expiration_date => "0220",
        :result => :success
      }
    @t.update(9, information)
    expected = @t.find_by_id(9)
    assert_equal :success, expected.result
    assert_equal "4242424242424242", expected.credit_card_number
    assert expected.updated_at > original_time
  end

  def test_delete
    @t.delete(9)
    assert_nil @t.find_by_id(9)
  end

  def test_credit_card_expiration
    expected = @t.find_by_id(1)
    assert_equal "0217",  expected.credit_card_expiration_date
    assert_equal String, expected.credit_card_expiration_date.class
  end
end
