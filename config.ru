require './giantpic.rb'
run Giantpic

use Rack::MethodOverride
use Rack::Session::Cookie
run Rack::Cascade.new [API, Giantpic]
