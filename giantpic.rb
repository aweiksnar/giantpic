require 'sinatra'
require 'sinatra/reloader' if development?
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'grape'

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
  property :email,    String
  property :password, String

  has n, :pictures
end

class Giantpic < Sinatra::Base
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
    pic = Picture.get(params[:id])
    pic.update(params[:picture])
    redirect "/image/#{pic.id}"
  end

  delete "/image/:id" do
    pic = Picture.get(params[:id])
    pic.destroy
    redirect :index
  end

  get "/sign_up" do
    erb :sign_up
  end

  get "/sign_in" do
    erb :sign_in
  end

  get "/user/:id" do
    erb :profile
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
