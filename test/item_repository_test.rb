# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/item_repository'
require './lib/repository_helper'

class ItemRepositoryTest < Minitest::Test
  def setup
    @attributes =
      {
        name: 'Capita Defenders of Awesome 2018',
        description: 'This board both rips and shreds',
        unit_price: BigDecimal(399.99, 5),
        created_at: Time.now,
        updated_at: Time.now,
        merchant_id: 25
      }

    items =
      [
        { id: 1,
          name: 'thing1',
          description: 'stuff1',
          unit_price: 1000,
          merchant_id: 1,
          created_at: '2016-01-11',
          updated_at: '1991-03-23' },
        { id: 2,
          name: 'thing2',
          description: 'stuff2',
          unit_price: 1000,
          merchant_id: 1,
          created_at: '2016-01-11',
          updated_at: '1991-03-23' },
        { id: 3,
          name: 'thing3',
          description: 'stuff3',
          unit_price: 1000,
          merchant_id: 2,
          created_at: '2016-01-11',
          updated_at: '1991-03-23' },
        { id: 4,
          name: 'thing4',
          description: 'stuff4',
          unit_price: 1500,
          merchant_id: 2,
          created_at: '2016-01-11',
          updated_at: '1991-03-23' },
        { id: 5,
          name: 'thing5',
          description: 'stuff5',
          unit_price: 1500,
          merchant_id: 2,
          created_at: '2016-01-11',
          updated_at: '1991-03-23' },
        { id: 6,
          name: 'thing6',
          description: 'stuff6',
          unit_price: 1500,
          merchant_id: 3,
          created_at: '2016-01-11',
          updated_at: '1991-03-23' },
        { id: 7,
          name: 'thing7',
          description: 'stuff7',
          unit_price: 2000,
          merchant_id: 3,
          created_at: '2016-01-11',
          updated_at: '1991-03-23' },
        { id: 8,
          name: 'thing8',
          description: 'stuff8',
          unit_price: 2000,
          merchant_id: 3,
          created_at: '2016-01-11',
          updated_at: '1991-03-23' },
        { id: 9,
          name: 'thing9',
          description: 'stuff9',
          unit_price: 2000,
          merchant_id: 4,
          created_at: '2016-01-11',
          updated_at: '1991-03-23' },
        { id: 10,
          name: 'thing10',
          description: 'stuff10',
          unit_price: 2500,
          merchant_id: 4,
          created_at: '2016-01-11',
          updated_at: '1991-03-23' }
      ]
    @mi = ItemRepository.new(items)
  end

  def test_it_exists
    assert_instance_of(ItemRepository, @mi)
  end

  def test_item_attributes
    item_one = @mi.all.first
    assert_equal 1, item_one.id
    item_two = @mi.all.last
    assert_equal 10, item_two.id
  end

  def test_it_creates_items_list
    assert_equal 'thing1', @mi.items[0].name
  end

  def test_all_returns_all_items
    assert_equal 10, @mi.all.length
  end

  def test_it_can_find_by_id
    id = 9
    expected = @mi.find_by_id(id)
    assert_equal 9, expected.id
    assert_equal 'thing9', expected.name
  end

  def test_it_returns_nil_if_no_id
    id = 12
    expected = @mi.find_by_id(id)
    assert_nil expected
  end

  def test_find_by_name
    name = 'thing8'
    expected = @mi.find_by_name(name)
    assert_equal 8, expected.id
    assert_equal name, expected.name
  end

  def test_find_all_by_description
    description = 'stuff1'
    expected = @mi.find_all_with_description(description)
    assert_equal description, expected.first.description
    assert_equal 1, expected.first.id
    description = 'Sales Engine is a relational database'
    expected = @mi.find_all_with_description(description)
    assert_equal 0, expected.length
  end

  def test_find_all_by_price
    price1 = BigDecimal(25)
    expected = @mi.find_all_by_price(price1)
    assert_equal 1, expected.length
    price2 = BigDecimal(10)
    expected = @mi.find_all_by_price(price2)
    assert_equal 3, expected.length
    price3 = BigDecimal(20_000)
    expected = @mi.find_all_by_price(price3)
    assert_equal 0, expected.length
  end

  def test_find_all_by_price_in_range
    range = (10.00..15.00)
    expected = @mi.find_all_by_price_in_range(range)
    assert_equal 6, expected.length
    range = (15.00..20.00)
    expected = @mi.find_all_by_price_in_range(range)
    assert_equal 6, expected.length
  end

  def test_find_all_by_merchant_id
    merchant_id = 2
    expected = @mi.find_all_by_merchant_id(merchant_id)
    assert_equal 3, expected.length
  end

  def test_create_makes_a_new_item_instance
    @mi.create(@attributes)
    expected = @mi.find_by_id(11)
    assert_equal 'Capita Defenders of Awesome 2018', expected.name
  end

  def test_update_updates_an_item
    @mi.create(@attributes)
    original_time = @mi.find_by_id(11).updated_at
    attributes =
      {
        unit_price: BigDecimal(379.99, 5)
      }
    @mi.update(11, attributes)
    expected = @mi.find_by_id(11)
    assert_equal 379.99, expected.unit_price
    assert original_time < expected.updated_at
  end

  def test_it_deletes_an_item
    @mi.create(@attributes)
    @mi.delete(11)
    assert_nil @mi.find_by_id(11)
  end
end
