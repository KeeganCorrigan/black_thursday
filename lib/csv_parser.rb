# frozen_string_literal: true

require 'csv'

class CsvParser
  attr_accessor :csv_file

  def initialize
    @csv_file = csv_file
  end

  def load_csv(csv_file)
    if csv_file.include?('transactions')
      CSV.foreach(csv_file, headers: true, header_converters: :symbol).map(&:to_h)
    else
      CSV.foreach(csv_file, headers: true, header_converters: :symbol, converters: :all).map(&:to_h)
    end
  end
end
