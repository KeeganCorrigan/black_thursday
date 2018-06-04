# frozen_string_literal: true

require_relative 'sales_engine'
require_relative 'repository_helper'
require_relative 'transaction'

class TransactionRepository < RepositoryHelper
  attr_reader :transactions

  def initialize(transactions)
    @table ||= create_transaction(transactions)
    @transactions = @table
  end

  def create_transaction(transactions)
    transactions.map do |row|
      Transaction.new(row)
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @transactions.find_all do |transaction|
      transaction.invoice_id == invoice_id
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    @transactions.find_all do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    @transactions.find_all do |transaction|
      transaction.result == result
    end
  end

  def generate_id_for_new_transaction
    @transactions.max_by(&:id).id + 1
  end

  def create(attributes)
    attributes[:id] = generate_id_for_new_transaction
    @transactions << Transaction.new(attributes)
  end

  def update(id, data)
    return if data.empty?
    transaction = find_by_id(id)
    transaction.credit_card_number = data[:credit_card_number] unless data[:credit_card_number].nil?
    transaction.credit_card_expiration_date = data[:credit_card_expiration_date] unless data[:credit_card_expiration_date].nil?
    transaction.result = data[:result] unless data[:result].nil?
    transaction.updated_at = Time.now
  end
end
