require './giantpic.rb'
run Giantpic

use Rack::MethodOverride
use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => "ENV['giantpic']"
run Rack::Cascade.new [API, Giantpic]
