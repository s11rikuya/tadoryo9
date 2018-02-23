require './myapp'
require 'rack-timeout'
use Rack::Timeout, service_timeout: 300
run SinatraOmniAuth
