require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'

require 'pry'

class SalesAnalystTest < Minitest::Test
  def test_it_exists
    analyst = SalesAnalyst.new
    assert_instance_of(SalesAnalyst, analyst)
  end

  def test_it_gets_items
    se = SalesEngine.new
    analyst = SalesAnalyst.new(se)
    analyst.get_items
  end
end
