class History
  require_relative 'fetch_facebook_data.rb'
  attr_accessor :from_time, :to_time
  def initialize(access_token, app_secret, from_time, to_time)
    @access_token = access_token
    @app_secret = app_secret
    @from_time = Time.parse(from_time)
    @to_time = Time.parse(to_time)
  end
  include GetFBData
end
