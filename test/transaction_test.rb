require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/transaction_repository'
require 'time'
require 'bigdecimal'
require 'pry'

class TransactionTest < Minitest::Test
  def setup
    @information = {
                  id: 1,
                  invoice_id: 1,
                  credit_card_number: "4848466917766328",
                  credit_card_expiration_date: "0220",
                  result: "success",
                  created_at: "2009-02-07",
                  updated_at: "2014-03-15"
                    }
  end

  def test_it_exists
    transaction = Transaction.new(@information)
    assert_instance_of(Transaction, transaction)
  end

  def test_it_has_attributes
    transaction = Transaction.new(@information)
    assert_equal 1, transaction.id
    assert_equal 1, transaction.invoice_id
    assert_equal "4848466917766328", transaction.credit_card_number
    assert_equal "0220", transaction.credit_card_expiration_date
    assert_equal "success", transaction.result
    assert_equal Time, transaction.created_at.class
    assert_equal Time, transaction.updated_at.class
  end
end
