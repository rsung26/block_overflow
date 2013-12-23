require 'bundler/setup'
Bundler.require(:default)

require 'pry'
#require 'sinatra/reloader'

require_relative 'models/post'
require_relative 'models/user'
require_relative 'models/comment'
require_relative 'models/like'
require_relative 'config'

enable :sessions


#Displays a User and its Posts
get '/' do
	if session[:username]
		@user = User.find_by_username(session[:username])
	else 
		@user = nil
	end

	@posts = Post.all
	erb :index
end

get '/posts' do
	redirect '/'
end


#Save a post into the database
post '/posts' do
  title = params[:title]
  body = params[:body]
  user = User.find_by_username(session[:username])
  post = Post.new(:title => title, :body => body)
  user.posts << post
  post.save
  redirect '/'
end

#Register a User
get '/users/sign_up' do 
	erb :sign_up
end

post '/users/sign_up' do 
	user = User.create(:username => params[:username])
	session[:username] = user.username
	redirect '/'
end


#Sign in a User
get '/users/sign_in' do 
	erb :sign_in
end

post '/users/sign_in' do 
  if user = User.find_by_username(params[:username])
  	session[:username] = user.username
  	redirect '/'
  else 
  	redirect '/users/sign_up'
  end
end

#Sign out a User
get '/users/sign_out' do 
	session[:username] = nil
	redirect '/'
end


#See User's Post
get '/users/:id' do
	@user = User.find(params[:id].to_i)
	erb :show
end

get '/user/:user_id/post/:post_id/view' do
	"VIEW"

end

get '/user/:user_id/post/:post_id/edit' do
	"EDIT"
end

get '/user/:user_id/post/:post_id/delete' do
	"DELETE"
end






post '/posts/:id/comments' do 
	user = User.find_by_username(session[:username])
	post = Post.find(params[:id].to_i)
	comment = Comment.new(:body => params[:comment_text])
	comment.save

	post.comments << comment
	user.comments << comment

	redirect '/'
end 

get '/posts/:id/like' do 
	
	user = User.find_by_username(session[:username])
	post = Post.find(params[:id].to_i)

	# like = Like.create
	# like.user = user
	# like.post = post
	# like.save

	user.faves << post

	redirect '/'
end