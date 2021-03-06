require 'rubygems'
require 'sinatra'
require 'erb'
require 'sass'
require 'sinatra/reloader' if development?
require 'sinatra/flash'
require 'net/http'
require 'uri'
require 'json'

require 'dm-core'
require 'dm-migrations'
require './stocks'
require './env' if development?

helpers do
	#Get data as JSON
	def findTicker(ticker)
		@key=ENV['key']
		uri = URI.parse("https://www.quandl.com/api/v1/datasets/WIKI/#{ticker}.json?trim_start=#{Date.today.year-1}-#{Date.today.month}-#{Date.today.day}&auth_token=#@key")
		response = Net::HTTP.get_response(uri)
		responseBody = response.body
		parsed=JSON.parse(responseBody)
		# puts "https://www.quandl.com/api/v1/datasets/WIKI/#{ticker}.json?trim_start=#{Date.today.year-1}-05-01&auth_token=#@key"
		return parsed
		#@average=averageReturn(parsed).to_s
	end

	#Get average return
	def averageReturn(ticker)
		total=0
		if ticker["data"]
			for i in ticker["data"]
				total+=i[3].to_f
			end
			return (total/ticker["data"].length).round(2)
		else 
			return "No information was found"
		end
	end


	#for Users
	def find_user
    Users.get(params[:id])
  end
  
  def passwordsMatch?(user, password)
    if password == user[:password]
      return true
    else
      return false
    end
  end

  def findUserInDB(id)
  	@usersTable.first(id: id)
  end

  def create_user 
    @rUser = Users.create(params[:rUser])
  end 
end