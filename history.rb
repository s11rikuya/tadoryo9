class History
  require_relative 'fetch_facebook_data.rb'
  attr_accessor :from_time, :to_time
  def initialize(access_token, app_secret)
    @access_token = access_token
    @app_secret = app_secret
  end
  include GetFBData
end
