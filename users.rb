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
  # def   
  #   @user = Users.create(params[:user])
  # end 
end

helpers LoginHelpers

get '/user' do
  @title="Login"
  erb :user
end

get '/user/register' do
  @title="Register"
  @rUser = Users.create(params[:rUser])
  erb :user_register
end

get '/login' do
  @title="Login"
  erb :login
end

post '/login' do
  @title="Login"
  # @user=Users.find_user
  erb :login
end

post '/user/register' do
  flash[:notice] = "Account created successfully" if create_user
  redirect to("/login")
  erb :show_user
end

get '/user/:id' do
  @title = Users.get(params[:id]).firstName.capitalize + " " + Users.get(params[:id]).lastName.capitalize + "\'s Account!"
  @user=find_user
  erb :show_user
end