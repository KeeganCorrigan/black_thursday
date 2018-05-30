require_relative 'sales_engine'
require_relative 'repository_helper'
require_relative 'merchant'

class MerchantRepository < RepositoryHelper
  attr_reader :merchants,
              :table

  def initialize(table)
    @table ||= create_merchant(table)
    @merchants = @table
  end

  def create_merchant(merchants)
    merchants.map do |row|
      Merchant.new(row)
    end
  end

  def find_all_by_name(name)
    @merchants.find_all { |merchant| merchant.name.downcase.include?(name.downcase) }
  end

  def create(attributes)
    attributes[:id] = generate_new_id
    @merchants << Merchant.new(attributes)
  end

  def update(id, name)
    return if name.empty?
    merchant_to_update = find_by_id(id)
    merchant_to_update.name = name[:name]
  end
end
