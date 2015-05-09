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

helpers do
  def averageReturn(ticker)
    total=0
    for i in ticker["data"]
      total+=i[3].to_f
      #ticker["data"][0][3].to_s
    end
    #puts total/ticker["data"].length
    return (total/ticker["data"].length).round(2)
  end
end

get '/api' do
  @key=ENV['key']
  @title="Temp, API, APPL"
  uri = URI.parse("https://www.quandl.com/api/v1/datasets/WIKI/AAPL.json?trim_start=2014-05-01&auth_token=#@key")

  # Shortcut
  response = Net::HTTP.get_response(uri)
  responseBody = response.body
  parsed=JSON.parse(responseBody)
  @average=averageReturn(parsed).to_s
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
