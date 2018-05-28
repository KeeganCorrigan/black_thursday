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
    assert_equal 1367, sa.items.length
  end

  def test_it_gets_merchants
    sa = SalesEngine.analyst
    assert_equal 475, sa.merchants.length
  end

  def test_it_groups_items_by_merchant
    sa = SalesEngine.analyst
    assert_equal 475, sa.items_by_merchant.length
  end

  def test_average_items_per_merchant
    sa = SalesEngine.analyst
    assert_equal 2.88, sa.average_items_per_merchant
    assert_equal Float, sa.average_items_per_merchant.class
  end

  def test_list_of_deviations
    sa = SalesEngine.analyst
    deviations = sa.list_of_deviations
    assert_equal Array, deviations.class
    assert_equal 475, deviations.length
    assert_equal -1.88, deviations[0]
  end

  def test_square_deviations
    sa = SalesEngine.analyst
    square_deviations = sa.square_deviations
    assert_equal Array, square_deviations.class
    assert_equal 475, square_deviations.length
    assert_equal 3.5343999999999998,  square_deviations[0]
  end

  def test_sum_of_deviations
    sa = SalesEngine.analyst
    sum = sa.sum_of_deviations
    assert_equal Float, sum.class
    assert_equal 5034.919999999936, sum
  end

  def test_average_items_per_merchant_standard_deviation
    sa = SalesEngine.analyst
    standard_deviation = sa.average_items_per_merchant_standard_deviation
    assert_equal 3.26, standard_deviation
    assert_equal Float, standard_deviation.class
  end

  def test_get_list_of_high_item_count_merchant_ids
    sa = SalesEngine.analyst
    assert_equal Array, sa.high_item_count_list.class
    assert_equal 52, sa.high_item_count_list.length
  end

  def test_merchants_with_high_item_count
    sa = SalesEngine.analyst
    assert_equal 52, sa.merchants_with_high_item_count.length
    assert_equal Merchant, sa.merchants.first.class
  end
end
