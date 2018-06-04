# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test
  def setup
    customers =
      [
        { id: 1,
          first_name: 'Joey',
          last_name: 'Ondricka',
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 2,
          first_name: 'Cecelia',
          last_name: 'Osinski',
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 3,
          first_name: 'Mariah',
          last_name: 'Toy',
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 4,
          first_name: 'Leanne',
          last_name: 'Braun',
          created_at: '2012-03-27',
          updated_at: '2012-03-27' },
        { id: 5,
          first_name: 'Sylvester',
          last_name: 'Nader',
          created_at: '2012-03-27',
          updated_at: '2012-03-27' }
      ]

    @attributes =
      { id: 6,
        first_name: 'Joan',
        last_name: 'Clarke',
        created_at: Time.now,
        updated_at: Time.now }

    @repo = CustomerRepository.new(customers)
  end

  def test_it_exists
    assert_instance_of(CustomerRepository, @repo)
  end

  def test_all_returns_all_customers
    assert_equal 5, @repo.all.length
  end

  def test_find_by_id
    expected = @repo.find_by_id(1)
    assert_equal 'Joey', expected.first_name
    assert_equal 'Ondricka', expected.last_name
    assert_equal 1, expected.id
  end

  def test_find_all_by_first_name
    expected = @repo.find_all_by_first_name('Joey')
    assert_equal 1, expected.length
    assert_equal Customer, expected.first.class
  end

  def test_find_all_by_last_name
    expected = @repo.find_all_by_last_name('Ondricka')
    assert_equal 1, expected.length
    assert_equal Customer, expected.first.class
  end

  def test_generates_customer_id
    assert_equal 6, @repo.generate_new_id
  end

  def test_create_makes_a_new_customer
    information =
      { first_name: 'Joan',
        last_name: 'Clarke',
        created_at: Time.now,
        updated_at: Time.now }
    @repo.create(information)
    expected = @repo.find_by_id(6)
    assert_equal 6, expected.id
    assert_equal 'Clarke', expected.last_name
  end

  def test_update_updates_a_customer
    original_time = @repo.find_by_id(5).updated_at
    new_attributes = { first_name: 'Jody', last_name: 'Foster' }
    @repo.update(5, new_attributes)
    expected = @repo.find_by_id(5)
    assert_equal 'Jody', expected.first_name
    assert_equal 'Foster', expected.last_name
    assert original_time < expected.updated_at
  end

  def test_deletes_removes_customer
    @repo.create(@attributes)
    @repo.delete(4)
    assert_nil @repo.find_by_id(4)
  end
end
