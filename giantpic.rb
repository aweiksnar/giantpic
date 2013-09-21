require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'data_mapper'
require 'grape'

DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/giantpic.db")

class Picture
  include DataMapper::Resource

  property :id,       Serial
  property :url,      String, :format => :url, :length => 2000, :required => true
  property :title,    String, :length => 50, :required => true
  property :caption,  String, :length => 255
  property :user_id,  Integer, :required => true

  belongs_to :user

  def was_submitted_by(current_user)
    self.user_id == current_user.id
  end
end

class User
  include DataMapper::Resource

  property :id,       Serial
  property :email,    String, :format => :email_address, :required => true, :unique => true, :length => 255
  property :password, BCryptHash, :required => true, :length => 60

  has n, :pictures
end

class Giantpic < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
    require "dm-sqlite-adapter"
  end

  configure :production do
    require "dm-postgres-adapter"
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
      flash[:errors] = ["Only the image owner can perform this action"]
      redirect :error
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
    pic = Picture.new(params[:picture])
    if pic.save
      redirect "/image/#{pic.id}"
    else
      @errors = pic.errors.full_messages
      erb :error
    end
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
    if pic.update(params[:picture])
      redirect "/image/#{pic.id}"
    else
      @errors = pic.errors.full_messages
      erb :error
    end
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
      session[:user_id] = user.id
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
    @pictures = Picture.all(:user_id => params[:id], :limit => 10, :order => [ :id.desc ])
    erb :index
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
