class History
  require_relative 'fetch_facebook_data.rb'
  include GetFBData
  require_relative 'point_calculation.rb'
  include PointCalculation
  attr_accessor :since_time, :until_time
  def initialize(access_token, app_secret)
    @access_token = access_token
    @app_secret = app_secret
  end
end
