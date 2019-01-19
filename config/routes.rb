Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	post "/carts" => "carts#create"
	get  "/carts" => "carts#index"
	get  "/cart/:id" => "carts#getCartById"
	post "/addProductToCart" => "carts#addProductToCart"
	get  "/products" => "products#index"
	post "/checkout" => "carts#checkout"


end
