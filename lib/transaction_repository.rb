require_relative 'sales_engine'
require_relative 'transaction'

class TransactionRepository
  attr_reader :transactions

  def initialize(transactions)
    @transactions ||= create_transaction(transactions)
  end

  def create_transaction(transactions)
    transactions.map do |row|
      Transaction.new(row)
    end
  end

  def inspect
   "#<#{self.class} #{@invoices.size} rows>"
  end

  def all
    @transactions
  end

  def find_by_id(id)
    @transactions.find {|transaction| transaction.id == id}
  end

  def find_all_by_invoice_id(invoice_id)
    @transactions.find_all {|transaction| transaction.invoice_id == invoice_id}
  end

  def find_all_by_credit_card_number(credit_card_number)
    @transactions.find_all {|transaction| transaction.credit_card_number == credit_card_number}
  end

  def find_all_by_result(result)
    @transactions.find_all {|transaction| transaction.result == result}
  end

  def generate_id_for_new_transaction
      (@transactions.max_by { |transaction| transaction.id }).id + 1
  end

  def create(attributes)
    attributes[:id] = generate_id_for_new_transaction
    @transactions << Transaction.new(attributes)
  end

  def update(id, information)
    return if information.empty?
    transaction_to_update = find_by_id(id)
    transaction_to_update.credit_card_number = information[:credit_card_number] if information[:credit_card_number] != nil
    transaction_to_update.credit_card_expiration_date = information[:credit_card_expiration_date] if information[:credit_card_expiration_date] != nil
    transaction_to_update.result = information[:result] if information[:result] != nil
    transaction_to_update.updated_at = Time.now
  end

  def delete(id)
    transaction_to_delete = find_by_id(id)
    @transactions.delete(transaction_to_delete)
  end
end