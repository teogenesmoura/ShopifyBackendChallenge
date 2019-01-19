Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	post "/addProductToCart" => "carts#addProductToCart"
	post "/checkout" => "carts#checkout"
	post "/carts" => "carts#create"
	get  "/carts" => "carts#index"
	get  "/products" => "products#index"
end
