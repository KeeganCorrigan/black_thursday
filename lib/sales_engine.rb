require_relative 'csv_parser'
require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'sales_analyst'
require 'pry'

class SalesEngine
  attr_reader :file_path,
              :items,
              :merchants

  def initialize(file_path = nil)
    @csv_parser = CsvParser.new
    @file_path = file_path
  end

  def self.analyst
    SalesAnalyst.new(self)
  end

  def self.from_csv(file_path)
    SalesEngine.new(file_path)
  end

  def merchants
    @merchants ||= MerchantRepository.new(@csv_parser.load_csv(file_path[:merchants]), self)
  end

  def items
    @items ||= ItemRepository.new(@csv_parser.load_csv(file_path[:items]), self)
  end
end
