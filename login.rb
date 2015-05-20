require './helpers'

class Logins
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
  def find_login
    Logins.get(params[:id])
  end
  def create_login
    @logins = Logins.create(params[:logins])
  end 
end

helpers LoginHelpers

get '/login' do
  @title="Login"
  erb :login
end

get '/login/register' do
  @title="Register"
  @logins = Logins.new
  erb :login_register
end

post '/login/register' do
  flash[:notice] = "Account created successfully" if create_login
  redirect to("/login/#{@logins.id}")
  erb :show_logins
end

get '/login/:id' do
  @title = Logins.get(params[:id]).firstName.capitalize + " " + Logins.get(params[:id]).lastName.capitalize + "\'s Account!"
  @logins=find_login
  erb :show_logins
end
