require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest

  test "should get a list of all products" do 
    get '/products'
    assert_response :success
  end 

  test "shoud create a product" do 
    product_count = Product.count 
    post product_url, params: { title: 'Test product', price: 1, inventory_count: 1}
    assert_not_equal product_count, Product.count 
  end

  test "should delete a product" do 
    post product_url, params: { title: 'Test product', price: 1, inventory_count: 0}
    test_product = Product.last.id 
    delete product_url, params: {id: test_product}
    new_last_product = Product.last.id 
    assert_not_equal test_product, new_last_product
  end 
end
