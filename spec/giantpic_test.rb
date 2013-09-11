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

  def test_it_has_a_new_image_page
    get "/images/new"

    assert last_response.ok?
  end

  def test_it_has_an_image_show_page
    get "/image/2"

    assert last_response.ok?
  end

  def test_it_has_an_image_edit_page
    get "/image/2/edit"

    assert last_response.ok?
  end

  def test_it_has_a_sign_up_page
    get "/sign_up"

    assert last_response.ok?
  end

  def test_it_has_a_sign_in_page
    get "/sign_in"

    assert last_response.ok?
  end

  def test_it_has_a_profile_page
    get "/user/1"

    assert last_response.ok?
  end
end

class UserTest < Test::Unit::TestCase

  def test_it_should_exist_when_created
    user = User.new

    assert_not_nil user
  end

  def test_it_should_respond_to_defined_attributes
    user = User.new

    assert_respond_to user, :id
    assert_respond_to user, :email
    assert_respond_to user, :password
    assert_respond_to user, :pictures
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
    assert_respond_to pic, :user
  end

  def test_it_can_be_created_with_attributes
    pic = Picture.new(:id => 1, :url => "http://www.example.com", :title => "Test Title", :caption => "Test Caption")

    assert_equal pic.id, 1
    assert_equal pic.url, "http://www.example.com"
    assert_equal pic.title, "Test Title"
    assert_equal pic.caption, "Test Caption"
  end

end
