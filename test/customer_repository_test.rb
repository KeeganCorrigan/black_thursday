# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test
  def setup
    @attributes = { id: 6,
                    first_name: 'Joan',
                    last_name: 'Clarke',
                    created_at: Time.now,
                    updated_at: Time.now }
    customer_info = { customers: './data/customers.csv' }
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
    assert_equal 'Genoveva', expected.first_name
    assert_equal 'Barrows', expected.last_name
    assert_equal 100, expected.id
  end

  def test_find_all_by_first_name
    expected = @c.find_all_by_first_name('ben')
    assert_equal 3, expected.length
    assert_equal Customer, expected.first.class
  end

  def test_find_all_by_last_name
    expected = @c.find_all_by_last_name('re')
    assert_equal 64, expected.length
    assert_equal Customer, expected.first.class
  end

  def test_generates_customer_id
    assert_equal 1001, @c.generate_new_id
  end

  def test_create_makes_a_new_customer
    information = { first_name: 'Joan',
                    last_name: 'Clarke',
                    created_at: Time.now,
                    updated_at: Time.now }
    @c.create(information)
    expected = @c.find_by_id(1001)
    assert_equal 1001, expected.id
    assert_equal 'Joan',  expected.first_name
    assert_equal 'Clarke', expected.last_name
  end

  def test_update_updates_a_customer
    @c.create(@attributes)
    original_time = @c.find_by_id(1001).updated_at
    new_attributes = { first_name: 'Jody',
                       last_name: 'Foster' }
    @c.update(1001, new_attributes)
    expected = @c.find_by_id(1001)
    assert_equal 'Jody', expected.first_name
    assert_equal 'Foster', expected.last_name
    assert original_time < expected.updated_at
  end

  def test_deletes_removes_customer
    @c.create(@attributes)
    @c.delete(1001)
    assert_nil @c.find_by_id(1001)
  end
end
