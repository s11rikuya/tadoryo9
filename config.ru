require './myapp'
require 'rack-timeout'
use Rack::Timeout, service_timeout: 60
run SinatraOmniAuth
