require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/sales_analyst'

require 'pry'

class SalesAnalystTest < Minitest::Test
  def setup
    data = {:merchants => "./data/merchants.csv", :items => "./data/items.csv", :invoices => "./data/invoices.csv", :invoice_items => "./data/invoice_items.csv", :transactions => "./data/transactions.csv"}
    @sales_engine = SalesEngine.from_csv(data)
    @sa = @sales_engine.analyst
  end

  def test_it_exists
    assert_instance_of(SalesAnalyst, @sa)
  end

  def test_it_gets_items
    assert_equal 1367, @sa.items.length
  end

  def test_it_gets_merchants
    assert_equal 475, @sa.merchants.length
  end

  def test_it_gets_invoices
    assert_equal 4985, @sa.invoices.length
  end

  def test_it_gets_invoice_items
    assert_equal 21830, @sa.invoice_items.length
  end

  def test_it_groups_items_by_merchant
    assert_equal 475, @sa.items_by_merchant.length
  end

  def test_average_items_per_merchant
    assert_equal 2.88, @sa.average_items_per_merchant
    assert_equal Float, @sa.average_items_per_merchant.class
  end

  def test_list_of_deviations
    mean = @sa.average_items_per_merchant
    deviations = @sa.list_of_deviations(@sa.items_by_merchant, mean)
    assert_equal Array, deviations.class
    assert_equal 475, deviations.length
    assert_equal -1.88, deviations[0]
  end

  def test_square_deviations
    mean = @sa.average_items_per_merchant
    deviations = @sa.list_of_deviations(@sa.items_by_merchant, mean)
    square_deviations = @sa.square_deviations(deviations)
    assert_equal Array, square_deviations.class
    assert_equal 475, square_deviations.length
    assert_equal 3.5343999999999998,  square_deviations[0]
  end

  def test_sum_of_deviations
    mean = @sa.average_items_per_merchant
    deviations = @sa.list_of_deviations(@sa.items_by_merchant, mean)
    square_deviations = @sa.square_deviations(deviations)
    sum = @sa.sum_of_deviations(square_deviations)
    assert_equal Float, sum.class
    assert_equal 5034.919999999936, sum
  end

  def test_average_items_per_merchant_standard_deviation
    standard_deviation = @sa.average_items_per_merchant_standard_deviation
    assert_equal 3.26, standard_deviation
    assert_equal Float, standard_deviation.class
  end

  def test_get_list_of_high_item_count_merchant_ids
    assert_equal Array, @sa.high_item_count_list.class
    assert_equal 52, @sa.high_item_count_list.length
  end

  def test_merchants_with_high_item_count
    assert_equal 52, @sa.merchants_with_high_item_count.length
    assert_equal Merchant, @sa.merchants.first.class
  end

  def test_calculate_average_price
    merchant_id = 12334105
    expected = @sa.calculate_average_price(merchant_id)
    assert_equal 16.656666666666666, expected.to_f
    assert_equal BigDecimal, expected.class
  end

  def test_average_item_price_for_merchant
    merchant_id = 12334105
    expected = @sa.average_item_price_for_merchant(merchant_id)
    assert_equal 16.66, expected
    assert_equal BigDecimal, expected.class
  end

  def test_average_average_price_per_merchant
    expected = @sa.average_average_price_per_merchant
    assert_equal 350.29, expected
    assert_equal BigDecimal, expected.class
  end

  def test_calculate_mean_for_items
    expected = @sa.calculate_mean(@sa.items)
    assert_equal 251.05510607168983, expected.to_f
    assert_equal BigDecimal, expected.class
  end

  def test_deviation_list_for_items
    mean = @sa.calculate_mean(@sa.items)
    expected = @sa.deviation_list_for_items(mean)
    assert_equal 1367, expected.length
    assert_equal Array, expected.class
  end

  def test_standard_deviation_for_items
    expected = @sa.standard_deviation_for_items
    assert_equal 2900, expected
  end

  def test_golden_items
    expected = @sa.golden_items
    assert_equal 5, expected.length
    assert_equal Item, expected.first.class
  end

  def test_group_invoices_by_merchant
    expected = @sa.invoices_by_merchant
    assert_equal 475, expected.length
  end

  def test_average_invoices_per_merchant
    expected = @sa.average_invoices_per_merchant
    assert_equal 10.49, expected
    assert_equal Float, expected.class
  end

  def test_average_invoices_per_merchant_standard_deviation
    expected = @sa.average_invoices_per_merchant_standard_deviation
    assert_equal 3.29, expected
    assert_equal Float, expected.class
  end

  def test_high_invoice_count_merchants
    expected = @sa.high_invoice_count_merchants
    assert_equal 12, expected.length
  end

  def test_top_merchants_by_invoice_count
    expected = @sa.top_merchants_by_invoice_count
    assert_equal 12, expected.length
    assert_equal Merchant, expected.first.class
  end

  def test_low_invoice_count_merchants
    expected = @sa.low_invoice_count_merchants
    assert_equal 4, expected.length
  end

  def test_bottom_merchants_by_invoice_count
    expected = @sa.bottom_merchants_by_invoice_count
    assert_equal 4, expected.length
    assert_equal Merchant, expected.first.class
  end

  def test_invoices_created_by_day
    expected = @sa.invoices_created_by_day
    assert_equal Array, expected.class
    assert_equal 4985, expected.length
  end

  def test_count_invoices_created_by_day
    expected = @sa.count_invoices_created_by_day
    assert_equal Hash, expected.class
    assert_equal 7, expected.length
  end

  def test_top_days_by_invoice_count
    expected = @sa.top_days_by_invoice_count
    assert_equal 1, expected.length
    assert_equal "Wednesday", expected.first
  end

  def test_invoice_status
    expected = @sa.invoice_status(:pending)
    assert_equal 29.55, expected
    expected = @sa.invoice_status(:shipped)
    assert_equal 56.95, expected
    expected = @sa.invoice_status(:returned)
    assert_equal 13.5, expected
  end

  def test_invoice_paid_in_full
    expected = sales_analyst.invoice_paid_in_full?(1)
    expect(expected).to eq true

    expected = sales_analyst.invoice_paid_in_full?(200)
    expect(expected).to eq true

    expected = sales_analyst.invoice_paid_in_full?(203)
    expect(expected).to eq false

    expected = sales_analyst.invoice_paid_in_full?(204)
    expect(expected).to eq false
  end
end
