require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'

require 'pry'

class SalesAnalystTest < Minitest::Test
  def test_it_exists
    sales_engine = SalesEngine.new
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
    mean = sa.average_items_per_merchant
    deviations = sa.list_of_deviations(mean)
    assert_equal Array, deviations.class
    assert_equal 475, deviations.length
    assert_equal -1.88, deviations[0]
  end

  def test_square_deviations
    sa = SalesEngine.analyst
    mean = sa.average_items_per_merchant
    deviations = sa.list_of_deviations(mean)
    square_deviations = sa.square_deviations(deviations)
    assert_equal Array, square_deviations.class
    assert_equal 475, square_deviations.length
    assert_equal 3.5343999999999998,  square_deviations[0]
  end

  def test_sum_of_deviations
    sa = SalesEngine.analyst
    mean = sa.average_items_per_merchant
    deviations = sa.list_of_deviations(mean)
    square_deviations = sa.square_deviations(deviations)
    sum = sa.sum_of_deviations(square_deviations)
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

  def test_calculate_average_price
    sa = SalesEngine.analyst
    merchant_id = 12334105
    expected = sa.calculate_average_price(merchant_id)
    assert_equal 16.656666666666666, expected.to_f
    assert_equal BigDecimal, expected.class
  end

  def test_average_item_price_for_merchant
    sa = SalesEngine.analyst
    merchant_id = 12334105
    expected = sa.average_item_price_for_merchant(merchant_id)
    assert_equal 16.66, expected
    assert_equal BigDecimal, expected.class
  end

  def test_average_average_price_per_merchant
    sa = SalesEngine.analyst
    expected = sa.average_average_price_per_merchant
    assert_equal 350.29, expected
    assert_equal BigDecimal, expected.class
  end

  def test_calculate_mean_for_items
    sa = SalesEngine.analyst
    expected = sa.calculate_mean_for_items
    assert_equal 251.05510607168983, expected.to_f
    assert_equal BigDecimal, expected.class
  end

  def test_deviation_list_for_items
    sa = SalesEngine.analyst
    mean = sa.calculate_mean_for_items
    expected = sa.deviation_list_for_items(mean)
    assert_equal 1367, expected.length
    assert_equal Array, expected.class
  end

  def test_standard_deviation_for_items
    sa = SalesEngine.analyst
    expected = sa.standard_deviation_for_items
    assert_equal 2900, expected
  end

  def test_golden_items
    sa = SalesEngine.analyst
    expected = sa.golden_items
    assert_equal 5, expected.length
    assert_equal Item, expected.first.class
  end
end
