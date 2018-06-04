# frozen_string_literal: true

require_relative 'sales_analyst'
require_relative 'math_helper'

class ItemAnalyst
  include MathHelper

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def golden_items
    @items.find_all do |item|
      item.unit_price > (standard_deviation_for_items * 2)
    end
  end

  def standard_deviation_for_items
    mean = calculate_mean(@items)
    squares = square_deviations(deviation_list_for_items(mean))
    sum = sum_of_deviations(squares)
    BigDecimal(Math.sqrt(sum / (@items.length - 1)), 3).to_f
  end

  def deviation_list_for_items(mean)
    @items.map { |item| item.unit_price - mean }
  end
end
