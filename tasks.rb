require './helpers'

class Tasks
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	property :date, Date
	property :details, String

	def date=date
	    super Date.strptime(date, '%m/%d/%Y')
	end
end

DataMapper.finalize

module TaskHelpers
  def find_tasks
    @tasks = Tasks.all
  end
  def find_task
    Tasks.get(params[:id])
  end
  def create_task
    @tasks = Tasks.create(params[:tasks])
  end 
end

helpers TaskHelpers

get '/tasks' do
  @title="All Tasks"
  find_tasks
  erb :tasks
end

get '/tasks/new' do
  @title="New Task"
  @tasks = Tasks.new
  erb :new_task
end

post '/tasks' do
  flash[:notice] = "Task created successfully" if create_task
  redirect to("/tasks/#{@tasks.id}")
end

get '/tasks/:id' do
  @title = Tasks.get(params[:id]).name
  @tasks=find_task
  erb :show_tasks
end

get '/tasks/:id/edit' do
  @title = "Edit " + Tasks.get(params[:id]).name
  @tasks=Tasks.get(params[:id])
  erb :edit_task
end

put '/tasks/:id' do
  @title = "Update " + Tasks.get(params[:id]).name
  tasks=find_task
  if tasks.update(params[:tasks])
    flash[:notice] = "Task successfully updated"
  end
  redirect to("/tasks/#{tasks.id}")
end

delete '/tasks/:id' do
  @title = "Delete " + Tasks.get(params[:id]).name
  find_task.destroy
  redirect to("/tasks")
end