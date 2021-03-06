# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/csv_parser'

class CsvParcerTest < Minitest::Test
  def test_it_exists
    csv = CsvParser.new
    assert_instance_of(CsvParser, csv)
  end

  def test_it_loads_a_file
    csv = CsvParser.new
    assert_equal Array, csv.load_csv('./data/merchants_test.csv').class
  end

  def test_file_is_correct_file
    csv = CsvParser.new
    expected = {  id: 1,
                  name: 'Shopin1901',
                  created_at: '2010-12-10',
                  updated_at: '2011-12-04' }
    assert_equal expected, csv.load_csv('./data/merchants_test.csv')[0]
  end

  def test_it_loads_all_files
    csv = CsvParser.new
    assert_equal 4, csv.load_csv('./data/merchants_test.csv').length
  end
end
