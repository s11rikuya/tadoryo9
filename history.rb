class History
  require_relative 'fetch_facebook_data.rb'
  require_relative 'point_calculation.rb'
  include GetFBData
  include PointCalculation
  attr_accessor :since_time, :until_time
  def initialize(access_token, app_secret)
    @access_token = access_token
    @app_secret = app_secret
  end
end
