require './helpers'

class Logins
	include DataMapper::Resource
	property :id, Serial
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
  #LOGIN FORM
end

get '/login/new' do
  @title="New Login"
  @logins = Logins.new
  erb :new_login
end

post '/login' do
  flash[:notice] = "Account created successfully" if create_login
  redirect to("/login/#{@logins.id}")
end

get '/login/:id' do
  @title = Logins.get(params[:id]).name
  @logins=find_login
  erb :show_logins
end
