require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'json'
require 'time'
require 'dotenv'
Dotenv.load

ACCSESS_TORKEN = ENV['ACCSESS_TORKEN']
APP_SCRET = ENV['APP_SCRET']
FROM_TIME = '2017/01/01'
TO_TIME = '2018/01/01'

get '/index' do
  require_relative 'fetch_facebook_data.rb'
  @title = "MyApp"
  class History
    attr_accessor :from_time, :to_time
    def initialize(accesss_torken,app_secret,from_time,to_time)
      @accsess_torken = accesss_torken
      @app_secret = app_secret
      @from_time = Time.parse(from_time)
      @to_time = Time.parse(to_time)
    end
    include GetFBData
  end
  my_history = History.new(ACCSESS_TORKEN,APP_SCRET,FROM_TIME,TO_TIME)
  data_indexs = my_history.getData()
  @from_time = my_history.from_time
  @to_time = my_history.to_time
  @range_indexs = my_history.filter(data_indexs)
  erb :index
end
