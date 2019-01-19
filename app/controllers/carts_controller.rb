# This class handles logic for Carts in our application 
class CartsController < ApplicationController

  # Lists all products in the database 
  # * *Returns* :
  #   - +Product+ -> JSON Object - list of all carts in the database or [] if Cart.count == 0
  def index
    @carts = Cart.all
    render json: @carts
  end

  # Returns a cart given an id 
  # * *Returns* :
  #   - +Cart+ -> JSON Object if id is found, else renders an error message
  def getCartById 
    id = params[:id]
    cart = Cart.find(id)
    if cart == nil 
      render json: '{ "message": "Cart not found"}'
    else 
      render json: cart
    end
  end 

  # Creates a new cart and returns a JSON that represents it 
  # * *Params* :
  #   - +title+ -> _String_ -  The title for the new cart 
  # * *Returns* :
  #   - +Cart+ -> _Cart_ _array_ - JSON object if cart is created, else renders an error message
  def create
    if not params[:title]
      render json: '{ "message": "A required field is missing"}'
    else 
      cart = Cart.new()
      cart.title = params[:title]
      cart.total_amount = 0.0
      if cart.save
        render json: cart
      else 
        render json: "An error has ocurred"
      end 
    end 
  end

  # Lets user finalize his or her buying process. It receives a cart id and handles 
  # inventory, subtracting 1 of each available product. It doesn't need to worry about
  # price because we already process the total amount during the purchase process. Cart's 
  # total_amount field goes to zero after checkout is succesful.
  # * *Params* :
  #   - +cartId+ -> _Integer_ - Id of the cart that is checking out 
  # * *Returns* :
  #   - +Object+ -> JSON object containing the cart updated with new values after checkout, as
  # well as a field with the amount charged from the client.
  # Example return value:
  #   "cart": {
  #       "id": 1,
  #       "title": "Harry's cart",
  #       "total_amount": 0,
  #       "created_at": "2019-01-19T17:10:58.712Z",
  #       "updated_at": "2019-01-19T17:11:15.006Z"
  #   },
  #   "amount_charged": 2
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

  # Deletes a product from a cart
  # * *Params* :
  #   - +cartId+ -> _Integer_ - Id of the cart requested
  #   - +id+ -> _Integer_ - The id of the product which will be removed from the cart
  # * *Returns* :
  #   - +Object+ -> _Cart_ - JSON object with updated Cart.products status, or error message if something 
  # goes wrong 
  def deleteProductFromCart
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

  # Adds a Product to a Cart instance
  # * *Params* :
  #   - +cartId+ -> _Integer_ - Id of the cart requested
  #   - +id+ -> _Integer_ - The id of the product which will be removed from the cart
  # * *Returns* :
  #   - +Object+ -> _Products_ _array_ - JSON with a listing of all products in the cart, including the new one
  def addProductToCart 
    if not params[:cartId] or not params[:productId]
      render json: '{ "message": "You need to inform both the cart id and the product id" }'
    else 
      cart = Cart.find(params[:cartId])
      if not cart 
        render json: '{ "message": "Cart not found" } '
      end
      prod = Product.find(params[:productId])
      if not prod 
        render json: '{ "message": "Product not found" }'
      end 
      if prod.inventory_count == 0
        render json: '{ "message": "No more units available of this product :( " }'
      else 
        cart.products << prod 
        cart.total_amount += prod.price
        cart.save 
        render json: cart.products 
      end 
    end 
  end

  # Gives a listing of all products in a cart 
  # * *Params* :
  #   - +cartId+ -> _Integer_ - Id of the cart requested
  # * *Returns* :
  #   - +Object+ -> _Product_ _array_ - A listing of all products included in the cart requested or 
  # error if cart id is not found 
  def productsInCart 
    if not params[:cartId]
      render json: '{ "message": "Please inform the id of the cart"}'
    else 
      render json: Cart.find(params[:cartId]).products 
    end 
  end 

  # Deletes a cart from the database given it's id 
  # ==== Attributes
  # * *Params* :
  #   - +id+ -> _Integer_ - The id of the cart which will be destroyed
  # * *Returns* :
  #   - +message+ -> _String_ - message Returns a message informing wether the operation was successful
  #   or not 
  def destroy 
    if not params[:id]
      render json: ' { "message": "Field cartId is missing" } '
    else 
      cart = Cart.find(params[:id])
      if cart.destroy 
        render json:  ' { "message": "Cart successfully deleted"}'
      else 
        render json:  '{ "message": "There was a problem with your request" }'
      end 
    end 
  end 

end
