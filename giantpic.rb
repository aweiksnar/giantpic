require 'sinatra'
# require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'grape'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/giantpic.db")

class Picture
  include DataMapper::Resource

  property :id,       Serial
  property :url,      Text
  property :title,    String
  property :caption,  Text
end

class Giantpic < Sinatra::Base
  get "/" do
    redirect :index
  end

  get "/index" do
    @pictures = Picture.all
    erb :index
  end

  delete "/image/:id" do
    pic = Picture.get(params[:id])
    pic.destroy
    redirect :index
  end

  get "/image/:id" do
    @picture = Picture.get(params[:id])
    erb :show
  end

  post "/images" do
    picture = Picture.create(params[:picture])
    redirect :index
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
    redirect :index
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


