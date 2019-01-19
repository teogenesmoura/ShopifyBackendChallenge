require 'test_helper'

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cart = carts(:one)
  end

  test "should create cart" do 
    assert_difference('Cart.count') do 
      post cart_url, params: {title: 'Test Cart'}
    end 
  end 

  test "should get cart by id" do 
    last = Cart.last.id
    post cart_url, params: {title: 'Test Cart'}
    newCart = Cart.last.id 
    assert_not_equal last, newCart
  end 

  test "should create a cart" do 
    carts_before = Cart.count 
    post cart_url, params: {title: 'New Cart'}
    carts_after = Cart.count 
    assert_not_equal carts_before, carts_after 
  end 

  test "should add product to a cart" do 
    #to guarantee there are at least 1 product and 1 cart in the db
    post product_url, params: { title: 'Test product', price: 1, inventory_count: 1}
    post cart_url, params: {title: 'Test Cart'} 
    product_id = Product.last.id
    cart_id = Cart.last.id 
    post "/addProductToCart", params: {cartId: cart_id, productId: product_id}
    cart_total_amount = Cart.find(cart_id).total_amount 
    assert_not_equal cart_total_amount, 0.0
  end 

  test "should checkout a cart" do 
    post product_url, params: { title: 'Test product', price: 1, inventory_count: 1}
    post cart_url, params: {title: 'Test Cart'} 
    product_id = Product.last.id
    cart_id = Cart.last.id  
    post "/addProductToCart", params: {cartId: cart_id, productId: product_id}
    post "/checkout", params: {cartId: cart_id}
    amount_charged = JSON.parse(@response.body)["amount_charged"]
    assert_equal 1,amount_charged
  end 
end
