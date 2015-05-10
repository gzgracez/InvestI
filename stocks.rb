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
  flash[:notice] = "Stock added successfully" if create_stock
  redirect to("/stocks/#{@stocks.id}")
end

get '/stocks/:id' do
  @title = find_stock.ticker
  @stocks=find_stock
  tickerJSON=findTicker("#{find_stock.ticker}")
  @average=averageReturn(tickerJSON)
  erb :show_stocks
end

get '/stocks/:id/edit' do
  @title = "Edit " + find_stock.ticker
  @stocks=find_stock
  erb :edit_stock
end

put '/stocks/:id' do
  @title = "Update " + find_stock.ticker
  stocks=find_stock
  if stocks.update(params[:stocks])
    flash[:notice] = "Stock successfully updated"
  end
  redirect to("/stocks/#{stocks.id}")
end

delete '/stocks/:id' do
  @title = "Delete " + find_stock.ticker
  find_stock.destroy
  redirect to("/stocks")
end