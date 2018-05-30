require 'bigdecimal'
require 'time'
require_relative 'transaction_repository'

class Transaction
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
    @credit_card_number = information[:credit_card_number]
    @credit_card_expiration_date = information[:credit_card_expiration_date]
    @result = information[:result].to_sym
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
