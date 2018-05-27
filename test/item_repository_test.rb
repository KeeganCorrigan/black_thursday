require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/item_repository'
require 'bigdecimal'
require 'pry'

class ItemRepositoryTest < Minitest::Test
  def setup
    item_info = {:items => "./data/items.csv"}
    se = SalesEngine.from_csv(item_info)
    @mi = se.items
  end

  def test_it_exists
    assert_instance_of(ItemRepository, @mi)
  end

  def test_item_attributes
    item_one = @mi.all.first
    assert_equal 263395237, item_one.id
    item_two = @mi.all.last
    assert_equal 263567474, item_two.id
  end

  def test_it_creates_items_list
    assert_equal "510+ RealPush Icon Set", @mi.items[0].name
  end

  def test_all_returns_all_items
    assert_equal 1367, @mi.all.length
  end

  def test_it_can_find_by_id
    id = 263538760
    expected = @mi.find_by_id(id)
    assert_equal 263538760, expected.id
    assert_equal "Puppy blankie", expected.name
  end

  def test_it_returns_nil_if_no_ID
    id = 1
    expected = @mi.find_by_id(id)
    assert_nil expected
  end

  def test_find_by_name
    name = "Puppy blankie"
    expected = @mi.find_by_name(name)
    assert_equal 263538760, expected.id
    assert_equal name, expected.name
  end

  def test_find_all_by_description
    description = "A large Yeti of sorts, casually devours a cow as the others watch numbly."
    expected = @mi.find_all_with_description(description)
    assert_equal description, expected.first.description
    assert_equal 263550472, expected.first.id
    description = "Sales Engine is a relational database"
    expected = @mi.find_all_with_description(description)
    assert_equal 0, expected.length
  end

  def test_find_all_by_price
    price_1 = BigDecimal.new(25)
    expected = @mi.find_all_by_price(price_1)
    assert_equal 79, expected.length
    price_2 = BigDecimal.new(10)
    expected = @mi.find_all_by_price(price_2)
    assert_equal 63, expected.length
    price_3 = BigDecimal.new(20000)
    expected = @mi.find_all_by_price(price_3)
    assert_equal 0, expected.length
  end

  def test_find_all_by_price_in_range
    range = (1000.00..1500.00)
    expected = @mi.find_all_by_price_in_range(range)
    assert_equal 19, expected.length
    range = (10.00..150.00)
    expected = @mi.find_all_by_price_in_range(range)
    assert_equal 910, expected.length
  end

  def test_find_all_by_merchant_id
    merchant_id = 12334326
    expected = @mi.find_all_by_merchant_id(merchant_id)
    assert_equal 6, expected.length
  end

  def test_create_makes_a_new_item_instance
    attributes = {
      name: "Capita Defenders of Awesome 2018",
      description: "This board both rips and shreds",
      unit_price: BigDecimal.new(399.99, 5),
      created_at: Time.now,
      updated_at: Time.now,
      merchant_id: 25
    }
    @mi.create(attributes)
    expected = @mi.find_by_id(263567475)
    assert_equal "Capita Defenders of Awesome 2018", expected.name
  end

  def test_update_updates_an_item
    attributes = {
      name: "Capita Defenders of Awesome 2018",
      description: "This board both rips and shreds",
      unit_price: BigDecimal.new(399.99, 5),
      created_at: Time.now,
      updated_at: Time.now,
      merchant_id: 25
    }
    @mi.create(attributes)
    original_time = @mi.find_by_id(263567475).updated_at
    attributes = {
      unit_price: BigDecimal.new(379.99, 5)
    }
    @mi.update(263567475, attributes)
    expected = @mi.find_by_id(263567475)
    assert_equal 379.99, expected.unit_price
    assert_equal "Capita Defenders of Awesome 2018", expected.name
    assert original_time < expected.updated_at
  end

  def test_it_deletes_an_item
    attributes = {
      name: "Capita Defenders of Awesome 2018",
      description: "This board both rips and shreds",
      unit_price: BigDecimal.new(399.99, 5),
      created_at: Time.now,
      updated_at: Time.now,
      merchant_id: 25
    }
    @mi.create(attributes)
    @mi.delete(263567475)
    assert_nil @mi.find_by_id(263567475)
  end
end
