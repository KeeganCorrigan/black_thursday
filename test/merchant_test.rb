# frozen_string_literal: true

require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/merchant_repository'

class MerchantTest < Minitest::Test
  def setup
    @merchants =
      {
        id: 1234,
        name: 'test',
        created_at: nil,
        updated_at: nil
      }
    @merchant = Merchant.new(@merchants)
  end

  def test_it_exists
    assert_instance_of(Merchant, @merchant)
  end

  def test_it_has_attributes
    assert_equal 1234, @merchant.id
    assert_equal 'test', @merchant.name
  end
end
