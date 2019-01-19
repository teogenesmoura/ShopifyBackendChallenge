class ProductsController < ApplicationController
  # Lists all products in the database 
  # * *Returns* :
  #   - +Product+ -> JSON Object - Product array in JSON format if cart is created, else renders an error message
  def index
    @products = Product.all
    render json: @products
  end

  # Creates a new product and returns a JSON that represents it 
  # * *Params* :
  #   - +title+ -> _String_ - The title for the new product 
  #   - +price+ -> _Float_ - price The price of the new product
  #   - +inventory_count+ -> _Integer_ - The amount of units available in stock for the item 
  # * *Returns* :
  #   - +Product+ -> JSON Object - Product in JSON format if cart is created, else renders an error message
  def create
    if not params[:title] or not params[:price] or not params[:inventory_count]
      render json: '{ "message": "A required field is missing"}'
    else 
      product = Product.new()
      product.title = params[:title]
      product.price = params[:price]
      product.inventory_count = params[:inventory_count]
      if product.save
        render json: product
      else 
        render json: "An error has ocurred"
      end 
    end 
  end

  # Deletes a product from the database given it's id 
  # ==== Attributes
  # * *Params* :
  #   - +id+ -> _Integer_ - The id of the product which will be destroyed
  # * *Returns* :
  #   - +message+ -> _String_ - message Returns a message informing wether the operation was successful
  #   or not 
  def destroy 
    if not params[:id]
      render json: ' { "message": "Field productId is missing" } '
    else 
      product = Product.find(params[:id])
      if product.destroy 
        render json:  ' { "message": "Product successfully deleted"}'
      else 
        render json:  '{ "message": "There was a problem with your request" }'
      end 
    end 
  end 
end
