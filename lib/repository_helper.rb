require 'bigdecimal'
require 'time'

class RepositoryHelper
  def initialize(table)
    @table = table
  end

  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end

  def all
    @table
  end

  def find_by_id(id)
    @table.find { |row| row.id == id }
  end

  def generate_new_id
    (@table.max_by { |row| row.id }).id + 1
  end

  def delete(id)
    to_delete = find_by_id(id)
    @table.delete(to_delete)
  end

  def find_by_name(name)
    @table.find { |row| row.name.downcase == name.downcase }
  end

  def find_all_by_merchant_id(merchant_id)
    @table.find_all {|row| row.merchant_id == merchant_id}
  end
end
