require 'sinatra/base'
require 'sinatra/reloader'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'grape'
require 'sinatra/flash'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/giantpic.db")

class Picture
  include DataMapper::Resource

  property :id,       Serial
  property :url,      String, :length => 2000
  property :title,    String, :length => 50
  property :caption,  String, :length => 255
  property :user_id,  Integer

  belongs_to :user
end

class User
  include DataMapper::Resource

  property :id,       Serial
  property :email,    String, :required => true, :unique => true
  property :password, String, :required => true

  has n, :pictures
end

class Giantpic < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  register Sinatra::Flash

  def current_user
    @current_user ||= User.first(:id => session[:user_id])
  end

  def signed_in?
    session[:user_id].present?
  end

  def validate_picture_belongs_to_current_user
    unless signed_in? && Picture.first(:id => params[:id]).user_id == current_user.id
      redirect :index
    end
  end

  get "/" do
    redirect :index
  end

  get "/index" do
    @pictures = Picture.all
    erb :index
  end

  get "/image/:id" do
    @picture = Picture.get(params[:id])
    erb :show
  end

  post "/images" do
    pic = Picture.create(params[:picture])
    redirect "/image/#{pic.id}"
  end

  get "/images/new" do
    erb :new
  end

  get "/image/:id/edit" do
    @picture = Picture.get(params[:id])
    erb :edit
  end

  patch "/image/:id" do
    validate_picture_belongs_to_current_user
    pic = Picture.get(params[:id])
    pic.update(params[:picture])
    redirect "/image/#{pic.id}"
  end

  delete "/image/:id" do
    validate_picture_belongs_to_current_user
    pic = Picture.get(params[:id])
    pic.destroy
    redirect :index
  end

  get "/sign_up" do
    erb :sign_up
  end

  post "/sign_up" do
    user = User.new(params[:user])
    if user.save
      redirect :index
    else
      @errors = user.errors.full_messages
      erb :error
    end
  end

  get "/sign_in" do
    erb :sign_in
  end

  post "/session/new" do
    user = User.first(:email => params[:user][:email])
    if user.present? && user.password == params[:user][:password]
      session[:user_id] = user.id
      redirect :index
    else
      flash[:errors] = ["Invalid username or password"]
      redirect :error
    end
  end

  delete "/sign_out" do
    session.clear
    redirect :index
  end

  get "/user/:id" do
    @user = User.get(params[:id])
    erb :profile
  end

  get "/error" do
    @errors = flash[:errors]
    erb :error
  end
end

class API < Grape::API
  format :json

  get "/index/api" do
    Picture.all
  end

  get "/image/:id/api" do
    Picture.get(params[:id])
  end
end

DataMapper.finalize
Picture.auto_upgrade!
User.auto_upgrade!
