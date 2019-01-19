class ProductsController < ApplicationController
  # GET /products
  def index
    @products = Product.all
    render json: @products
  end

  # POST /product
  # Creates a new product and returns a JSON that represents it 
  # @params String title The title for the new product 
  # @params Float price The price for the new product
  # @params Integer inventory_count The amount of units available in stock for the item 
  # @return Product in JSON format if cart is create, else renders an error message
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

  # DELETE /product
  # Deletes a product from the database given it's id 
  # @params Integer id The id of the product which will be destroyed
  # @returns String message Returns a message informing wether the operation was successful
  # or not 
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
