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

get '/api/?' do
  @title="Temp, API, AAPL"
  tickerJSON=findTicker("AAPL")
  erb :api
end

get '/' do
  @title = "InvestI's Home Page!"
  @id = session[:id]
  user = findUserInDB(session[:id])
  if user
    @firstName = user[:firstName]
    @lastName = user[:lastName]
    if user[:username] = admin
      @admin = true 
    else 
      @admin = false
    end
  end
  erb :home
end

post '/' do 
  @usersTable = Users.all
  @usersTable.each do |k|
    puts k[:username]
  end
  user = @usersTable.first(username: params[:username])
  puts params[:username]
  puts params[:password]
  if !user || !passwordsMatch?(user,params[:password])
    @error = "Email/Password is invalid"
    erb :home
  else
    session[:id] = user[:id]
    puts user[:username]
    redirect '/'
  end
  erb :home
end

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