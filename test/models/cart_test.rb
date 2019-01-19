require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "should create cart" do 
    cart = Cart.create(title: 'Test Cart')
    assert_equal Cart.last.title, 'Test Cart'
  end 
end
