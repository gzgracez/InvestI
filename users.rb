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

module LoginHelpers
  def find_user
    Users.get(params[:id])
  end
  # def setUserInfo(user)
  #   @user.username = user[username]
  #   @user.password = user[password]
  # end
  def create_user 
    @rUser = Users.create(params[:rUser])
  end 
end

helpers LoginHelpers

get '/user/?' do
  @title="Login"
  erb :user
end

get '/register/?' do
  @title = "Register"
  @rUser = Users.create(params[:rUser])
  erb :user_register
end

post '/register' do
  flash[:notice] = "Account created successfully" if create_user
  puts @rUser
  puts @rUser.username
  redirect to("/login")
  erb :show_user
end

get '/login/?' do
  @title="Login"
  erb :login
end

post '/login' do
  @title="Login"
  # Code like the following:
  # user = @users_table.where(:name == params[:name]).first
  # if user.nil? || not check_password(user, params[:password]) 
  user = @users_table.get(:username => params[:username])
  if !user.nil?  
    puts user[:username]
  end
  # if user.nil? || not check_password(user, params[:password])

  # params.each do |k, v|
  #   puts "Key: #{k}\nValue: #{v}"
  # end
  erb :login
end

get '/user/:id' do
  @title = Users.get(params[:id]).firstName.capitalize + " " + Users.get(params[:id]).lastName.capitalize + "\'s Account!"
  @user=find_user
  erb :show_user
end