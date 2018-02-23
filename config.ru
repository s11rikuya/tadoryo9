require './myapp'
require 'rack-timeout'
use Rack::Timeout, service_timeout: 0, wait_timeout: 0
run SinatraOmniAuth
