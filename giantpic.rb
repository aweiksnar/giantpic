require 'sinatra'
require 'sinatra/reloader' if development?
require 'data_mapper'
require 'dm-sqlite-adapter'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/giantpic.db")

class Picture
  include DataMapper::Resource

  property :id,       Serial
  property :url,      String
  property :title,    String
  property :caption,  Text
end

get "/" do
  redirect :index
end

get "/index" do
  @pictures = Picture.all
  erb :index
end

post "/index" do
  @picture = Picture.create(params[:picture])
  "Saved" unless @picture.nil?
end

get "/new" do
  erb :new
end


DataMapper.finalize

Picture.auto_upgrade!

