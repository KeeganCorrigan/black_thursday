require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'

require 'pry'

class SalesAnalystTest < Minitest::Test
  def test_it_exists
    sa = SalesEngine.analyst
    assert_instance_of(SalesAnalyst, sa)
  end

  def test_it_gets_items
    sa = SalesEngine.analyst
    binding.pry
    assert_equal 1367, sa.items.length
  end

  def test_it_groups_items_by_merchant
    sa = SalesEngine.analyst
    assert_equal 475, sa.items_by_merchant.length
  end
end
