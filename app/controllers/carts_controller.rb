class CartsController < ApplicationController
  # before_action :set_cart, only: [:show, :edit, :update, :destroy]
  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
    render json: @carts
  end

  # GET /cart
  def getCartById 
    id = params[:id]
    cart = Cart.find(id)
    if cart == nil 
      render json: '{ "message": "Cart not found"}'
    else 
      render json: cart
    end
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

  #POST /deleteProductFromChart
  def deleteProductFromChart
    if not params[:cartId] or not params[:productId]
      render json: '{ "message": "You need to inform both the cart id and the product id" }'
      return 
    else 
      cart = Cart.find(params[:cartId])
      product = Product.find(params[:productId])
      if not cart 
        render json: '{ "message": "Cart not found" } '
        return 
      end
      if not product  
        render json: '{ "message": "Product not found" }'
        return 
      end 
      for prod in cart.products 
        puts prod.id
        puts "params prod id " + params[:productId]
        if prod.id == params[:productId].to_i
          cart.total_amount -= prod.price 
          cart.products.delete(prod)
          cart.save
          render json: cart 
          return 
        end
      end 
      render json: '{ "message": "Product not found in cart" }' 
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

  # GET /productsInCart
  def productsInCart 
    if not params[:cartId]
      render json: '{ "message": "Please inform the id of the cart"}'
    else 
      render json: Cart.find(params[:cartId]).products 
    end 
  end 

end
