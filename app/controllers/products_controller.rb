class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

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
  # DELETE /products/1.json
  # def destroy
  #   @product.destroy
  #   respond_to do |format|
  #     format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end
end
