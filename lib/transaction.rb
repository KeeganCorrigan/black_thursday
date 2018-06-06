# frozen_string_literal: true

require_relative 'transaction_repository'
require_relative 'data_helper'

class Transaction
  include DataHelper

  attr_reader   :id,
                :invoice_id,
                :created_at

  attr_accessor :credit_card_number,
                :credit_card_expiration_date,
                :result,
                :updated_at

  def initialize(data)
    @id = data[:id].to_i
    @invoice_id = data[:invoice_id].to_i
    @credit_card_number = data[:credit_card_number].to_s
    @credit_card_expiration_date = data[:credit_card_expiration_date].to_s
    @result = data[:result].to_sym
    @created_at = convert_time(data[:created_at])
    @updated_at = convert_time(data[:updated_at])
  end
end
