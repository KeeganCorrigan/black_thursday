require 'bigdecimal'
require 'time'
require_relative 'invoice_repository'

class Invoice
  attr_reader :id, :customer_id, :merchant_id, :created_at

  attr_accessor :status, :updated_at

  def initialize(information)
    @id = information[:id]
    @customer_id = information[:customer_id]
    @merchant_id = information[:merchant_id]
    @status = information[:status].to_sym
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
