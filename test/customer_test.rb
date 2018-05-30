require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/customer_repository'
require 'time'
require 'pry'

class CustomerTest < Minitest::Test

  def setup
    @information = {
                    :id => 6,
                    :first_name => "Joan",
                    :last_name => "Clarke",
                    :created_at => Time.now,
                    :updated_at => Time.now
                  }
  end

  def test_it_exists
    customer = Customer.new(@information)
    assert_instance_of(Customer, customer)
  end

  def test_it_has_attributes
    customer = Customer.new(@information)
    assert_equal 6, customer.id
    assert_equal "Joan", customer.first_name
    assert_equal "Clarke", customer.last_name
    assert_equal Time, customer.created_at.class
    assert_equal Time, customer.updated_at.class
  end
end
