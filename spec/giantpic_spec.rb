ENV['RACK_ENV'] = 'test'

require "./giantpic.rb"
require "rspec"
require "rack/test"
require "spec_helper"

describe "The Giantpic App" do
  include Rack::Test::Methods

  def app
    Giantpic.new!
  end

  it "should redirect to the index page as the root url" do
    get "/"
    follow_redirect!

    expect(last_response).to be_ok
    expect("/index").to eq(last_request.path)
  end

  it "should have an index page" do
    get "/index"

    expect(last_response).to be_ok
  end

  it "should have a new image page" do
    get "/images/new"

    expect(last_response).to be_ok
  end

  it "should have an image show page" do
    get "/image/2"

    expect(last_response).to be_ok
  end

  it "should have an image edit page" do
    get "/image/2/edit"

    expect(last_response).to be_ok
  end

  it "should have a sign up page" do
    get "/sign_up"

    expect(last_response).to be_ok
  end

  it "should have a sign in page" do
    get "/sign_in"

    expect(last_response).to be_ok
  end

  it "should have a profile page" do
    user = User.new
    get "/user/1"

    expect(last_response).to be_ok
  end

  describe "User" do

    it "should exist when created" do
      user = User.new

      expect(user).not_to be_nil
    end

    it "should respond to defined attributes" do
      user = User.new

      expect(user).to respond_to(:id)
      expect(user).to respond_to(:email)
      expect(user).to respond_to(:password)
    end

    it "should respond to pictures (as per has many)" do
      user = User.new

      expect(user).to respond_to(:pictures)
    end
  end

  describe "A Picture" do

    it "should exist when created" do
      pic = Picture.new

      expect(pic).not_to be_nil
    end

    it "should respond to defined attributes" do
      pic = Picture.new

      expect(pic).to respond_to(:id)
      expect(pic).to respond_to(:url)
      expect(pic).to respond_to(:title)
      expect(pic).to respond_to(:caption)
    end

    it "can be created with attributes" do
      pic = Picture.new(:id => 1, :url => "http://www.example.com", :title => "Test Title", :caption => "Test Caption")

      expect(pic.id).to eq(1)
      expect(pic.url).to eq("http://www.example.com")
      expect(pic.title).to eq("Test Title")
      expect(pic.caption).to eq("Test Caption")
    end

    it "should be connected to a user through a user_id attribute" do
      user =  User.new(:id => 1)
      photo = Picture.new(:user_id => 1)

      expect(photo.user_id).to eq(user.id)
    end

    it "should respond to user (as per belongs to)" do
      picture = Picture.new

      expect(picture).to respond_to(:user)
    end
  end

  describe "Instance Methods" do
    it "should have a current_user defined" do
      expect(app).to respond_to(:current_user)
    end

    it "should have a signed_in? method" do
      expect(app).to respond_to(:signed_in?)
    end

    it "should have a validate_picture_belongs_to_current_user method" do
      expect(app).to respond_to(:validate_picture_belongs_to_current_user)
    end
  end

end
