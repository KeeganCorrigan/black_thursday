require_relative 'sales_engine'

class SalesAnalyst
  attr_reader :parent, :items, :items_by_merchant, :merchants, :high_item_count_list

  def initialize(parent)
    @parent = parent
    @items ||= get_items
    @merchants ||= get_merchants
    @items_by_merchant ||= group_items
    @high_item_count_list ||= list_of_high_item_count_merchant_ids
  end

  def golden_items
    @items.find_all do |item|
      item.unit_price > (standard_deviation_for_items * 2)
    end
  end

  def average_items_per_merchant
    BigDecimal.new((@items.length.to_f / @items_by_merchant.length), 3).to_f
  end

  def average_average_price_per_merchant
    average_price = @items_by_merchant.map { |merchant_id, items|
      calculate_average_price(merchant_id)}.reduce(:+) / @merchants.length
    BigDecimal.new(average_price.to_f, 5)
  end


  def average_item_price_for_merchant(merchant_id)
    BigDecimal.new(calculate_average_price(merchant_id).to_f, 4)
  end

  def calculate_average_price(merchant_id)
    @items_by_merchant[merchant_id].map { |item| item.unit_price}.reduce(:+) / @items_by_merchant[merchant_id].length
  end

  def merchants_with_high_item_count
    @merchants.find_all do |merchant|
      @high_item_count_list.include?(merchant.id)
    end
  end

  def list_of_high_item_count_merchant_ids
    @items_by_merchant.map do |merchant_id, merchant|
      if merchant.count > (average_items_per_merchant_standard_deviation * 2)
        merchant_id
      end
    end.compact.uniq
  end

  def get_items
    item_repo = parent.from_csv({:items => "./data/items.csv"})
    item_repo.items.items
  end

  def get_merchants
    merchant_repo = parent.from_csv({:merchants => "./data/merchants.csv"})
    merchant_repo.merchants.merchants
  end

  def group_items
    items_by_merchant = @items.each_with_object({}) do |item, accumulator|
      if accumulator[item.merchant_id]
        accumulator[item.merchant_id] << item
      else
        accumulator[item.merchant_id] = [item]
      end
    end
  end

  def calculate_mean_for_items
    @items.map { |item| item.unit_price }.reduce(:+) / @items.length
  end

  def deviation_list_for_items(mean)
    @items.map do |item|
      item.unit_price - mean
    end
  end

  def standard_deviation_for_items
    mean = calculate_mean_for_items
    squares = square_deviations(deviation_list_for_items(mean))
    sum = sum_of_deviations(squares)
    BigDecimal.new(Math.sqrt(sum / (@items.length - 1)), 3).to_f
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    squares = square_deviations(list_of_deviations(mean))
    sum = sum_of_deviations(squares)
    BigDecimal.new(Math.sqrt(sum / (@items_by_merchant.length - 1)), 3).to_f
  end

  def sum_of_deviations(squares)
    squares.inject do |sum, deviation|
      sum + deviation
    end
  end

  def list_of_deviations(mean)
    @items_by_merchant.map do |merchant_id, merchant|
      merchant.count - mean
    end
  end

  def square_deviations(list_of_deviations)
    list_of_deviations.map do |deviation|
      deviation ** 2
    end
  end

end
