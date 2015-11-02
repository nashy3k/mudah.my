enable :sessions

get '/' do
	session.delete(:user_id)
	@users = User.all
  	erb :"static/index"
end

get '/users/:id/edit' do
	@user = User.find(session[:user_id])
		erb :"static/profile"
end

get '/static/main' do
	@user = User.find(session[:user_id])
		erb :"static/main"
end

post '/signup' do
	#create a new User
	@user = User.new(email: params[:user][:email], password: params[:user][:password])
	if @user.save
		# @message = "Signed up. You may login"
		session[:user_id] = @user.id
		session[:user_name] = @user.username
		redirect to '/users/:id/edit'
		# return @url.to_json        
	else
		@users = User.all
		redirect to '/'
	end
end

post '/profile' do
	#update a User profile
	@user = User.find(session[:user_id])
	@user.update_attributes(username: params[:user][:username], first_name: params[:user][:first_name], last_name: params[:user][:last_name], email: params[:user][:email], password: params[:user][:password])
	if @user
		redirect to '/products'
		# return @url.to_json
	else
		redirect to '/users/:id/edit'
	end	
end

post '/login' do
# apply your authentication method to check if a user has entered a valid email and password
# if a user has successfully been authenticated, you can assign the current user id to a session
	if @user = User.authenticate(params[:user][:email], params[:user][:password])
	session[:user_id] = @user.id
	session[:user_name] = @user.username	
	redirect to '/products'
	else
		redirect to '/'
	end
end

get '/logout' do
# kill a session when a user choses to logout, for example assign nil to a session
# redirect to the appropriate page
	session.delete(:user_id)
	redirect to '/'
end

get '/products/new' do
	@products = Product.all
  	erb :"static/main"
end

post '/products' do
	product = current_user.products.new(params[:product])
	if product.save
		# @message = "Product asked"
	
		redirect to "/products/#{product.id}/edit"
		# return @url.to_json        
	else
		@products = Product.all
		redirect to '/products'
	end

end

get '/products' do
	@products = Product.all
	# @product_users = Product.joins(:user).all
	# product_users = Product.joins(:user).where(users: {username: session{:user_name})
  	erb :"static/main"
end

get '/products/:id' do
	@product = Product.find(params[:id])
  	erb :"static/product"
end

get '/user/:id/products/' do
	@products = Product.where(user_id: params[:id])
  	erb :"static/user_products"

end

get '/user/:id/favourites/' do
	@products = Product.where(user_id: params[:id])
	@favourites = Favourite.where(user_id: params[:id], status: '1')
  	erb :"static/user_favourites"	
end

get '/products/:id/edit' do
	# @product_users = User.joins(:products).all
	@product = Product.find(params[:id])
	if session[:user_id] == @product.user_id
  	erb :"static/product_edit"
  else
  	erb :"static/not_allowed"	
  end	
end

post '/products/:id/edit' do
	#update a Product
	@product = Product.find(params[:id])
	@product.update_attributes(title: params[:product][:title], description: params[:product][:description],price: params[:product][:price])
	if @product
		redirect to '/products'
		# return @url.to_json
	else
		redirect to '/products/:id/edit'
	end	
end

delete '/products/:id' do
	product = Product.find(params[:id])
if session[:user_id] == product.user_id
	product.destroy
	redirect to '/products'	
	else
  	erb :"static/not_allowed"	
  end
end

# #--------------------------Favourites-------------
 
get "/products/:p_id/favourites/new" do
	@product = Product.find(params[:p_id])
	@favourite = Favourite.find_by(product_id: params[:p_id])
	if session[:user_id] == @product.user_id
		erb :"static/not_allowed"
  # elsif session[:user_id] != @product.user_id 
  	# && @favourite.status == 1
		# erb :"static/not_allowed"
  else
  	erb :"static/submit_favourite"
  end		
end

post "/products/:p_id/favourites" do
	favourite = current_user.favourites.new(params[:favourite].merge({product_id: params[:p_id]}))
	if favourite.save
		# @message = "Product asked"
		redirect to "/products/#{params[:p_id]}/favourites"
		# return @url.to_json        
	else
		# redirect to "/products/#{params[:p_id]}/favourites/new"
		erb :"static/not_allowed"
	end
end

get "/products/:p_id/favourites" do
	@product = Product.find(params[:p_id])
	@favourites = Favourite.where(product_id: params[:p_id], status: '1')
	# if session[:user_id] == @product.user_id
	# 	erb :"static/not_allowed"
  # elsif session[:user_id] != @product.user_id && @favourites.status == 1
		# erb :"static/not_allowed"
  # else
  	erb :"static/all_favourites"	
  # end		
end

get '/products/:p_id/favourites/:f_id/' do
	@product = Product.find(params[:p_id])
	@favourite = Favourite.find(params[:f_id])
  	erb :"static/favourite"	
end

get '/products/:p_id/favourites/:f_id/edit' do
	@product = Product.find(params[:p_id])	
	@favourite = Favourite.find(params[:f_id])
	if session[:user_id] == @favourite.user_id		
  	erb :"static/favourite_edit"	
  else
  	erb :"static/not_allowed"	
  end	
end

post '/products/:p_id/favourites/:f_id/edit' do
	#update an Favourite
	@product = Product.find(params[:p_id])
	@favourite = Favourite.find(params[:f_id])
	@favourite.update_attributes(status: params[:favourite][:status])
	if @favourite
		redirect to "/products/#{params[:p_id]}/favourites"
		# return @url.to_json
	else
		redirect to "/products/"#{params[:p_id]}/favourites/#{params[:f_id]/edit
	end	
end

delete '/products/:p_id/favourites/:f_id' do
	favourite = Favourite.find(params[:f_id])
	if session[:user_id] == favourite.user_id		
	favourite.destroy
	redirect to "/products/#{params[:p_id]}/favourites"	
	else
  	erb :"static/not_allowed"	
  end	
end

delete '/products/:p_id/favourites' do
	product = Product.find(params[:p_id])
	if session[:user_id] == product.user_id		
	product.favourites.destroy_all 
	redirect to "/products/#{params[:p_id]}/favourites"	
	else
  	erb :"static/not_allowed"	
  end	
end