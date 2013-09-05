ENV['RACK_ENV'] = 'test'

require "./giantpic"
require "rspec"
require "rack/test"

describe "The Giantpic App" do
  include Rack::Test::Methods

  def app
    Giantpic
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
end

describe "Picture" do

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

end
