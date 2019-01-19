class CartsController < ApplicationController
  # before_action :set_cart, only: [:show, :edit, :update, :destroy]

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
    render json: @carts
  end

  # POST /carts
  def create
    if not params[:title]
      render json: '{ "message": "A required field is missing"}'
    else 
      @cart = Cart.new()
      @cart.title = params[:title]
      @cart.total_amount = 0.0
      if @cart.save
        render json: @cart
      else 
        render json: "An error has ocurred"
      end 
    end 
  end

  # POST /checkout
  def checkout
    if not params[:cartId]
      render json: '{ "message": "In order to checkout you need to inform the id of the Cart" }' 
    else 
      @cart = Cart.find(params[:cartId])
      if not @cart
        render json: '{ "message": "Cart not found" } '
      end 
      products = @cart.products
      for prod in products
        if prod.inventory_count > 0        
          prod.inventory_count -= 1
        end 
      end 
      if @cart.save 
        amount_charged = @cart.total_amount
        @cart.total_amount = 0
        result = {:cart => @cart, :amount_charged => amount_charged}
        render json: result
      else 
        render json: '{ "message": "An error has ocurred in your checkout process" }'
      end 
    end
  end 

  # POST /addProductToCart
  def addProductToCart 
    if not params[:cartId] or not params[:productId]
      render json: '{ "message": "You need to inform both the cart id and the product id" }'
    else 
      @cart = Cart.find(params[:cartId])
      if not @cart 
        render json: '{ "message": "Cart not found" } '
      end
      @prod = Product.find(params[:productId])
      if not @prod 
        render json: '{ "message": "Product not found" }'
      end 
      if @prod.inventory_count == 0
        render json: '{ "message": "No more units available of this product :( " }'
      else 
        @cart.products << @prod 
        @cart.total_amount += @prod.price
        @cart.save 
        render json: @cart.products 
      end 
    end 
  end


  # # PATCH/PUT /carts/1
  # # PATCH/PUT /carts/1.json
  # def update
  #   respond_to do |format|
  #     if @cart.update(cart_params)
  #       format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @cart }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @cart.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /carts/1
  # # DELETE /carts/1.json
  # def destroy
  #   @cart.destroy
  #   respond_to do |format|
  #     format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_cart
  #     @cart = Cart.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def cart_params
  #     params.fetch(:cart, {})
  #   end
end
