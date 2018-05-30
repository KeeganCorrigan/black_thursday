# loads CSV files and passes them to the sales engine.
require 'csv'
require 'pry'

class CsvParser
  attr_accessor :csv_file

  def initialize
    @csv_file = csv_file
  end

  def load_csv(csv_file)
    # REFACTOR - check header for credit_card_expiration_date to convert appropriately.
    if csv_file.include?"transactions"
      data = CSV.foreach(csv_file, headers: true, header_converters: :symbol).map { |row|
          row.to_h }
    else
      data = CSV.foreach(csv_file, headers: true, header_converters: :symbol, converters: :all).map { |row|
          row.to_h }
    end
    return data
  end
end
