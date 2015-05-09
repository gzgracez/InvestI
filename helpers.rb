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

		uri = URI.parse("https://www.quandl.com/api/v1/datasets/WIKI/#{ticker}.json?trim_start=2014-05-01&auth_token=#@key")
		response = Net::HTTP.get_response(uri)
		responseBody = response.body
		parsed=JSON.parse(responseBody)
		return parsed
		#@average=averageReturn(parsed).to_s
	end

	#Get average return
	def averageReturn(ticker)
		total=0
		for i in ticker["data"]
			total+=i[3].to_f
		end
		return (total/ticker["data"].length).round(2)
	end
end