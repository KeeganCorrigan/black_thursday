require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/customer_repository'
require 'bigdecimal'
require 'pry'

class CustomerRepositoryTest < Minitest::Test
  def setup
    @attributes = {
                    :id => 6,
                    :first_name => "Joan",
                    :last_name => "Clarke",
                    :created_at => Time.now,
                    :updated_at => Time.now
                  }
    customer_info = {:customers => "./data/customers.csv"}
    se = SalesEngine.from_csv(customer_info)
    @c = se.customers
  end

  def test_it_exists
    assert_instance_of(CustomerRepository, @c)
  end

  def test_all_returns_all_customers
    assert_equal 1000, @c.all.length
  end

  def test_find_by_id
    expected = @c.find_by_id(100)
    assert_equal "Genoveva", expected.first_name
    assert_equal "Barrows", expected.last_name
    assert_equal 100, expected.id
  end

  def test_find_all_by_first_name
    expected = @c.find_all_by_first_name("ben")
    assert_equal 3, expected.length
    assert_equal Customer, expected.first.class
  end

  def test_find_all_by_last_name
    expected = @c.find_all_by_last_name("re")
    assert_equal 64, expected.length
    assert_equal Customer, expected.first.class
  end

  def test_generates_customer_id
    assert_equal 1001, @c.generate_id_for_new_customer
  end

  def test_create_makes_a_new_customer
    information = {
                :first_name => "Joan",
                :last_name => "Clarke",
                :created_at => Time.now,
                :updated_at => Time.now
                }
    @c.create(information)
    expected = @c.find_by_id(1001)
    assert_equal 1001, expected.id
    assert_equal "Joan",  expected.first_name
    assert_equal "Clarke", expected.last_name
  end

  def test_update_updates_a_customer
    skip
    @c.create(@attributes)
    new_customer = @c.find_by_id(1001)
    new_attributes = {
                    :first_name => "Jody",
                    :last_name => "Foster",
                    }
    expected = new_customer.update
    assert_equal "Jody", expected.first_name
    assert_equal "Foster", expected.last_name
  end
end

# all - returns an array of all known Customers instances
# find_by_id - returns either nil or an instance of Customer with a matching ID
# find_all_by_first_name - returns either [] or one or more matches which have a first name matching the substring fragment supplied
# find_all_by_last_name - returns either [] or one or more matches which have a last name matching the substring fragment supplied
# create(attributes) - create a new Customer instance with the provided attributes. The new Customer’s id should be the current highest Customer id plus 1.
# update(id, attribute) - update the Customer instance with the corresponding id with the provided attributes. Only the customer’s first_name and last_name can be updated. This method will also change the customer’s updated_at attribute to the current time.
# delete(id) - delete the Customer instance with the corresponding id
