require 'sinatra'
require 'sinatra/reloader'
require 'dm-core'
require 'dm-migrations'

# Setup the connection to the database
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/parthladani.db")

# Student class for DataMapper
class Student
	include DataMapper::Resource
    property :sid, Serial
	property :fname, String
	property :lname, String
	property :address, String
	property :dob, Date
end

# Saves the changes for the database
DataMapper.finalize
DataMapper.auto_upgrade!

# Lists all the Students
get '/students' do
	@students = Student.all
	@title = "Student Information"
	erb :students
end

# Add new student form
get '/students/new' do
	if session[:isStarted]==true
		@student=Student.new
		erb :add_student
	else
		redirect to('/login')
	end
end

# Shows a single student
get '/students/:sid' do
	@student = Student.get(params[:sid])
	erb :display_student
end

# Create new student
post '/students' do  
  student = Student.create(params[:stud])
  student.save
  redirect to("/students/#{student.sid}")
end

# Update all the fields of a particular student ID
post '/students/:sid' do
	if session[:isStarted]==true
		student=Student.get(params[:sid])
		student.update(params[:stud])
		redirect to("/students/#{student.sid}")
	else
		redirect to('/login')
	end
end

# Delete a particular student
delete '/students/:sid' do
	if session[:isStarted]==true
  		Student.get(params[:sid]).destroy
		redirect to('/students')
	else
		redirect to('/login')
	end
		
end

# Form to edit a single student
get '/students/:sid/edit' do
	if session[:isStarted]==true
		@student = Student.get(params[:sid])
		erb :edit_student
	else
		redirect to('/login')
	end
end