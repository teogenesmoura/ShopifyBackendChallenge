class ProductsController < ApplicationController
  # GET /products
  def index
    @products = Product.all
    render json: @products
  end

  # POST /product
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

  # DELETE /products/1
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
