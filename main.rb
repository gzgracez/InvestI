require 'sinatra'
require './helpers'
require './tasks'
require './stocks'
require './users'
require './env' if development?

#get('/styles.css'){ scss :styles, :syntax => :scss, :style => :compressed }
enable :sessions

def initialize
  @usersTable = Users.all
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

before do
  @usersTable = Users.all
end

get '/api/?' do
  @title = "Temp, API, AAPL"
  tickerJSON = findTicker("AAPL")
  @average = averageReturn(tickerJSON)
  erb :api
end

get '/' do
  @title = "InvestI's Home Page!"
  @id = session[:id]
  user = findUserInDB(session[:id])
  if user 
    @firstName = user[:firstName]
    @lastName = user[:lastName]
    if user[:username]=="admin"
      @admin = true
    else 
      @admin = false
    end
  end
  erb :home
end

post '/' do 
  user = @usersTable.first(username: params[:username])
  if !user || !passwordsMatch?(user,params[:password])
    @error = "Email/Password is invalid"
    erb :home
  else
    session[:id] = user[:id]
    @firstName = user[:firstName]
    @lastName = user[:lastName]
    if user[:username] = "admin"
      @admin = true 
    else 
      @admin = false
    end
    redirect '/'
  end
  erb :home
end

# get '/users/:id/edit/?' do
#   @title = "Edit " + Users.get(params[:id]).username
#   @tasks=Tasks.get(params[:id])
#   erb :edit_task
# end

# put '/users/:id' do
#   @title = "Update " + Users.get(params[:id]).name
#   tasks=find_task
#   if tasks.update(params[:tasks])
#     flash[:notice] = "Task successfully updated"
#   end
#   redirect to("/tasks/#{tasks.id}")
# end

# delete '/users/:id' do
#   @title = "Delete " + Users.get(params[:id]).name
#   find_task.destroy
#   redirect to("/tasks")
# end

get '/test/?' do
  @title="InvestI's Test Page"
  test="test"
  "Hello #{test}"
  erb :test
end

get '/reload/?' do
  @title="InvestI's Reload Page"
  test="reload"
  "Hello #{test}"
  erb :reload
end

not_found do
  @title="404 Error"
  erb :not_found, :layout => false
end

helpers do
  def current?(path='/')
    (request.path==path || request.path==path+'/') ? "current" : nil
  end
end