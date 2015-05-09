require 'sinatra'
require './helpers'
require './tasks'
require './stocks'
require './env' if development?

#get('/styles.css'){ scss :styles, :syntax => :scss, :style => :compressed }

enable :sessions

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

get '/api' do
  @title="Temp, API, APPL"
  tickerJSON=findTicker("APPL")
  @average=averageReturn(tickerJSON)
  erb :api
end

get '/' do
  @title = "InvestI's Home Page!"
  erb :home
end

get '/test' do
  @title="InvestI's Test Page"
  test="test"
  "Hello #{test}"
  erb :test
end

get '/reload' do
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



#get '/:name' do
#	name = params[:name]
#	"Hi there #{name}!"
#end
