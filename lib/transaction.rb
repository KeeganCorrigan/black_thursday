require 'bigdecimal'
require 'time'
require_relative 'transaction_repository'

class Transaction
  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at

  def initialize(information)
    @id = information[:id]
    @invoice_id = information[:invoice_id]
    @credit_card_number = information[:credit_card_number]
    @credit_card_expiration_date = information[:credit_card_expiration_date]
    @result = information[:result]
    @created_at = convert_time(information[:created_at])
    @updated_at = convert_time(information[:updated_at])
  end

  def convert_time(time)
    if time.class == String
      Time.parse(time)
    else
      return time
    end
  end
end
