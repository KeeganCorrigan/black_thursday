# frozen_string_literal: true

require_relative 'invoice_repository'
require_relative 'data_helper.rb'

class Invoice
  include DataHelper

  attr_reader   :id,
                :customer_id,
                :merchant_id,
                :created_at

  attr_accessor :status,
                :updated_at

  def initialize(information)
    @id = information[:id]
    @customer_id = information[:customer_id]
    @merchant_id = information[:merchant_id]
    @status = information[:status].to_sym
    @created_at = convert_time(information[:created_at])
    @updated_at = convert_time(information[:updated_at])
  end
end
