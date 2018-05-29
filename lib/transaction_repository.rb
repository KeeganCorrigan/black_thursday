require_relative 'sales_engine'
require_relative 'transaction'

class TransactionRepository
  attr_reader :transactions

  def initialize(invoices)
    @transactions ||= create_transaction(transactions)
  end

  def create_transaction(transacions)
    transactions.map do |row|
      Transaction.new(row)
    end
  end

  def inspect
   "#<#{self.class} #{@invoices.size} rows>"
  end
end
