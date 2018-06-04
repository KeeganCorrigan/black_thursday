# frozen_string_literal: true

require_relative 'sales_engine'
require_relative 'repository_helper'
require_relative 'customer'

class CustomerRepository < RepositoryHelper
  attr_reader :customers,
              :table

  def initialize(customers)
    @table ||= create_customer(customers)
    @customers = @table
  end

  def create_customer(customers)
    customers.map do |row|
      Customer.new(row)
    end
  end

  def find_all_by_first_name(first_name)
    @customers.find_all do |customer|
      customer.first_name.downcase.include?(first_name.downcase)
    end
  end

  def find_all_by_last_name(last_name)
    @customers.find_all do |customer|
      customer.last_name.downcase.include?(last_name.downcase)
    end
  end

  def create(attributes)
    attributes[:id] = generate_new_id
    @customers << Customer.new(attributes)
  end

  def update(id, data)
    return if data.empty?
    cust = find_by_id(id)
    cust.first_name = data[:first_name] unless data[:first_name].nil?
    cust.last_name = data[:last_name] unless data[:last_name].nil?
    cust.updated_at = Time.now
  end
end
