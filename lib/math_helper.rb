module MathHelper
  def square_deviations(list_of_deviations)
    list_of_deviations.map {|deviation| deviation ** 2}
  end

  def sum_of_deviations(squares)
    squares.inject {|sum, deviation| sum + deviation}
  end

  def list_of_deviations(joins_table, mean)
    joins_table.map {|id, data| data.count - mean}
  end

  def calculate_mean(table)
    table.map {|row| row.unit_price }.reduce(:+) / table.length
  end
end
