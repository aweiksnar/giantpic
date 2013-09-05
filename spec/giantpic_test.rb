ENV['RACK_ENV'] = 'test'

require "./giantpic"
require "test/unit"
require "rack/test"

class GiantpicTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Giantpic
  end

  def test_it_should_redirect_to_index_page_as_root_path
    get "/"
    follow_redirect!

    assert_equal "/index", last_request.path
    assert last_response.ok?
  end

  def test_it_has_an_index_page
    get '/index'

    assert last_response.ok?
  end
end

class PictureTest < Test::Unit::TestCase

  def test_it_should_exist_when_created
    pic = Picture.new

    assert_not_nil pic
  end

  def test_it_responds_to_defined_attributes
    pic = Picture.new

    assert_respond_to pic, :id
    assert_respond_to pic, :url
    assert_respond_to pic, :title
    assert_respond_to pic, :caption
  end

  def test_it_can_be_created_with_attributes
    pic = Picture.new(:id => 1, :url => "http://www.example.com", :title => "Test Title", :caption => "Test Caption")

    assert_equal pic.id, 1
    assert_equal pic.url, "http://www.example.com"
    assert_equal pic.title, "Test Title"
    assert_equal pic.caption, "Test Caption"
  end

end
