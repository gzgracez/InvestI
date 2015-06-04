require './helpers'

class Users
	include DataMapper::Resource
	property :id, Serial
  property :firstName, String
  property :lastName, String
	property :username, String
	property :password, String
	property :email, String
end

DataMapper.finalize

# get '/user/?' do
#   @title="Login"
#   erb :user
# end

get '/register/?' do
  @title = "Register"
  @rUser = Users.new
  puts params[:username]
  erb :user_register
end

post '/register' do
  # puts params[:rUser][:username]
  if @usersTable.first(username: params[:rUser][:username]).nil?
    @rUser = Users.create(params[:rUser])
    flash[:notice] = "Account created successfully"
    redirect to("/")
  else
    flash[:error] = "Username already taken."
    redirect to("/register")
   # if create_user
  end
  erb :show_user
end

get '/logout/?' do
  session.clear
  redirect '/'
end

get '/users/?' do 
  user = findUserInDB(session[:id])
  if user && user[:username] = "admin"
    erb :allUsers
  else 
    erb :notLoggedIn
  end
end

# get '/user/:id' do
#   @title = Users.get(params[:id]).firstName.capitalize + " " + Users.get(params[:id]).lastName.capitalize + "\'s Account!"
#   @user = find_user
#   erb :show_user
# end