class UsersController < ApplicationController

  get '/users/:id' do
    if !logged_in?
      redirect '/lists'
    end

    @user = User.find(params[:id])
    if @user == current_user && !@user.nil?
      erb :'users/show'
    else
      redirect '/lists'
    end
  end
  
  get '/signup' do
    if !session[:user_id]
      erb :'users/new'
    else
      redirect to '/tasks'
    end
  end

  post '/signup' do
    if params[:user_name] == "" || params[:password] == ""
      redirect to '/signup'
    else 
      @user = User.create(username: params[:username], password: params[:password])
      session[:user_id] = @user.id
      redirect "/lists"
    end
  end

  get '/login' do
    @error_message = params[:error]
    if !session[:user_id]
      erb :'users/login'
    else
      redirect '/lists'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/lists"
    else
      redirect "/signup"
    end
  end

  get '/logout' do
    if session[:user_id] != nil
      session.clear
      redirect to '/login'
    else
      redirect to '/'
    end
  end


end