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
  def find_logins
    @logins = Logins.all
  end
  def find_login
    Logins.get(params[:id])
  end
  def create_login
    @logins = Logins.create(params[:logins])
  end 
end

helpers LoginHelpers

get '/logins' do
  @title="All Logins"
  find_logins
  erb :logins
end

get '/logins/new' do
  @title="New Login"
  @logins = Logins.new
  erb :new_login
end

post '/logins' do
  flash[:notice] = "Login created successfully" if create_login
  redirect to("/logins/#{@logins.id}")
end

get '/logins/:id' do
  @title = Logins.get(params[:id]).name
  @logins=find_login
  erb :show_logins
end

get '/logins/:id/edit' do
  @title = "Edit " + Logins.get(params[:id]).name
  @logins=Logins.get(params[:id])
  erb :edit_login
end

put '/logins/:id' do
  @title = "Update " + Logins.get(params[:id]).name
  logins=find_login
  if logins.update(params[:logins])
    flash[:notice] = "Login successfully updated"
  end
  redirect to("/logins/#{logins.id}")
end

delete '/logins/:id' do
  @title = "Delete " + Logins.get(params[:id]).name
  find_login.destroy
  redirect to("/logins")
end