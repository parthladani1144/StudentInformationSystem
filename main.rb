require 'sinatra'
require 'sinatra/reloader'
require 'sass'
require './students.rb'
require './comments.rb'
require 'dm-timestamps'
require 'bundler/setup'


# For session management
configure do
	enable :sessions
	set :username, "parthladani"
	set :password, "parth123"
end

# Helper method to check for admin all the time
helpers do 
	def isStarted?
		session[:isStarted]
	end
end

get '/' do
  @title = "Student Information System"
  erb :home
end

get '/about' do
  @title = "About Me"
  erb :about
end

get '/contact' do
  @title = "Contact Us"
  erb :contact
end

get '/login' do
  @title = "Login"
  erb :login
end

post '/login' do
	if params[:username]==settings.username && params[:password]==settings.password
    session[:isStarted]=true
    erb :afterlogin
	else
		erb :wronglogin
		
	end
end

get '/logout' do
  session[:isStarted]=false
  session.clear
  erb :home
end

get '/video' do
  @title = "Student Information System"
  erb :video
end

not_found do
  @title = "Student Information System"
  erb :notfound
end

get '/style.css' do
  scss :style
end