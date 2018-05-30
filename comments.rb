require 'sinatra'
require 'sinatra/reloader'
require 'dm-core'
require 'dm-migrations'

# Setup the connection to the database
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/parthladani.db")

# Comment class for DataMapper
class Comment
	include DataMapper::Resource
	property :cid, Serial
	property :comment, String
	property :name, String
	property :created_at, Time
end

# Saves the changes for the database
DataMapper.finalize
DataMapper.auto_upgrade!

# Lists all the Comments
get '/comments' do
	@comments = Comment.all
	@title = "Comments"
	erb :comments
end

# Add new comment form
get '/comments/new' do
    if session[:isStarted]==true
	    @comment=Comment.new
        erb :add_comments
    else
		redirect to('/login')
	end
end

# Shows a single comment
get '/comments/:cid' do
	@comment = Comment.get(params[:cid])
	erb :display_comment
end

# Delete a particular comment
delete '/comments/:cid' do
	if session[:isStarted]==true
  		Comment.get(params[:cid]).destroy
		redirect to('/comments')
	else
		redirect to('/login')
	end		
end

# Create new comment
post '/comments' do  
  comment = Comment.create(params[:comment])
  comment.save
  redirect to("/comments/#{comment.cid}")
end

# Shows single comment after adding
get '/comments/:cid/viewdetails' do
	@comment=Comment.get(params[:cid])
	erb :display_comment
end