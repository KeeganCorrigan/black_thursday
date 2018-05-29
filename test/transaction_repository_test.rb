require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/transaction_repository'
require 'bigdecimal'
require 'pry'

class TransactionRepositoryTest < Minitest::Test
  def setup
    transaction_info = {:transactions => "./data/transactions.csv"}
    se = SalesEngine.from_csv(transaction_info)
    @t = se.transactions
  end

  def test_it_exists
    assert_instance_of(TransactionRepository, @t)
  end
end
