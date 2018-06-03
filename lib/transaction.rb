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

  def initialize(information)
    @id = information[:id].to_i
    @invoice_id = information[:invoice_id].to_i
    @credit_card_number = information[:credit_card_number].to_s
    @credit_card_expiration_date = information[:credit_card_expiration_date].to_s
    @result = information[:result].to_sym
    @created_at = convert_time(information[:created_at])
    @updated_at = convert_time(information[:updated_at])
  end
end
