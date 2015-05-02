require './helpers'

class Stocks
	include DataMapper::Resource
	property :id, Serial
	property :ticker, String
	property :date, Date
	property :details, String

	def date=date
	    super Date.strptime(date, '%m/%d/%Y')
	end
end

DataMapper.finalize

module StockHelpers
  def find_stocks
    @stocks = Stocks.all
  end
  def find_stock
    Stocks.get(params[:id])
  end
  def create_stock
    @stocks = Stocks.create(params[:stocks])
  end 
end

helpers StockHelpers

get '/stocks' do
  @title="All Stocks"
  find_stocks
  erb :stocks
end

get '/stocks/new' do
  @title="New Stock"
  @stocks = Stocks.new
  erb :new_stock
end

post '/stocks' do
  flash[:notice] = "Task created successfully" if create_task
  redirect to("/stocks/#{@stocks.id}")
end

get '/stocks/:id' do
  @title = Stocks.get(params[:id]).name
  @stocks=find_task
  erb :show_stocks
end

get '/stocks/:id/edit' do
  @title = "Edit " + Stocks.get(params[:id]).name
  @stocks=Stocks.get(params[:id])
  erb :edit_task
end

put '/stocks/:id' do
  @title = "Update " + Stocks.get(params[:id]).name
  stocks=find_task
  if stocks.update(params[:stocks])
    flash[:notice] = "Task successfully updated"
  end
  redirect to("/stocks/#{stocks.id}")
end

delete '/stocks/:id' do
  @title = "Delete " + Stocks.get(params[:id]).name
  find_task.destroy
  redirect to("/stocks")
end