module MathHelper
  def square_deviations(list_of_deviations)
    list_of_deviations.map do |deviation|
      deviation ** 2
    end
  end

  def sum_of_deviations(squares)
    squares.inject do |sum, deviation|
      sum + deviation
    end
  end
end
