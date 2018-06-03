require 'bigdecimal'
require 'time'
require_relative 'item_repository'
require_relative 'data_helper'

class Item
  include DataHelper

    attr_reader :id,
                :merchant_id

  attr_accessor :name,
                :description,
                :unit_price,
                :updated_at,
                :created_at

  def initialize(information)
    @id = information[:id]
    @name = information[:name]
    @description = information[:description]
    @unit_price = (BigDecimal.new(information[:unit_price])) / 100
    @merchant_id = information[:merchant_id]
    @created_at = convert_time(information[:created_at])
    @updated_at = convert_time(information[:updated_at])
  end
  
  def unit_price_to_dollars
    @unit_price.to_f
  end
end
