# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/merchant_item_analyst'

class RevenueAnalystTest < Minitest::Test
  def test_it_exists
    ra = RevenueAnalyst.new
    assert_instance_of(RevenueAnalyst, ra)
  end



end
