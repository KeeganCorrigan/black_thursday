require_relative 'test_helper.rb'
require './lib/sales_engine'
require './lib/merchant_repository'
require 'pry'

class MerchantTest < Minitest::Test
  def test_it_exists
    information = {
                  id: 1234,
                  name: "test",
                  created_at: nil,
                  updated_at: nil
                    }
    merchant = Merchant.new(information)
    assert_instance_of(Merchant, merchant)
  end

  def test_it_has_attributes
    information = {
                  id: 1234,
                  name: "test",
                  created_at: nil,
                  updated_at: nil
                    }
    merchant = Merchant.new(information)
    assert_equal 1234, merchant.id
    assert_equal "test", merchant.name
  end
end
