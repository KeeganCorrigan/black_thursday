# frozen_string_literal: false

require_relative 'customer_repository'
require_relative 'data_helper'

class Customer
  include DataHelper

  attr_accessor :first_name,
                :last_name,
                :updated_at

  attr_reader   :id,
                :created_at

  def initialize(information)
    @id = information[:id]
    @first_name = information[:first_name]
    @last_name = information[:last_name]
    @created_at = convert_time(information[:created_at])
    @updated_at = convert_time(information[:updated_at])
  end
end
