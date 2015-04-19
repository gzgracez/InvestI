require 'sinatra'
require './helpers'
require './tasks'
require './file'

#get('/styles.css'){ scss :styles, :syntax => :scss, :style => :compressed }

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end





get '/api' do
  @title="api"
  uri = URI.parse("https://www.quandl.com/api/v1/datasets/WIKI/AAPL.csv?auth_token=#$key")

  # Shortcut
  response = Net::HTTP.get_response(uri)

  # Will print response.body
  Net::HTTP.get_print(uri)

  # Full
  # http = Net::HTTP.new(uri.host, uri.port)
  # response = http.request(Net::HTTP::Get.new(uri.request_uri))
end





get '/' do
  @title = "testSinatra's Home Page!"
  erb :home
end

get '/test' do
  @title="testSinatra's Test Page"
  test="test"
  "Hello #{test}"
  erb :test
end

get '/reload' do
  @title="testSinatra's Reload Page"
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
