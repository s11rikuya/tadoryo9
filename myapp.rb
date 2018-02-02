require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'json'
require 'time'
require 'dotenv'
Dotenv.load

ACCESS_TOKEN = ENV['ACCESS_TOKEN']
APP_SCRET = ENV['APP_SCRET']
FROM_TIME = '2016/01/01'.freeze
TO_TIME = '2016/10/01'.freeze

get '/index' do
  require_relative 'fetch_facebook_data.rb'
  @title = 'Tadoryo9'
  class History
    attr_accessor :from_time, :to_time
    def initialize(access_token, app_secret, from_time, to_time)
      @access_token = access_token
      @app_secret = app_secret
      @from_time = Time.parse(from_time)
      @to_time = Time.parse(to_time)
    end
    include GetFBData
  end
  my_history = History.new(ACCESS_TOKEN, APP_SCRET, FROM_TIME, TO_TIME)
  data_indexs = my_history.gets_data
  @from_time = my_history.from_time
  @to_time = my_history.to_time
  @range_indexs = my_history.filter(data_indexs)
  erb :index
end
