require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'json'
require 'koala'
require 'time'
require 'dotenv'
Dotenv.load

get '/index' do
  require_relative 'fetch_facebook_data.rb'
  @title = "MyApp"
  ACSESS_TORKEN = ENV['ACSESS_TORKEN']
  APP_SCRET = ENV['APP_SCRET']
  FROM_TIME = '2017/01/01'
  TO_TIME = '2018/01/01'
  class History
    include GetFBData
  end
  my_history = History.new()
  @from_time = Time.parse(FROM_TIME)
  @to_time = Time.parse(TO_TIME)
  data_indexs = my_history.getData()
  @range_indexs = my_history.filter(data_indexs,@from_time,@to_time)
  erb :index
end
