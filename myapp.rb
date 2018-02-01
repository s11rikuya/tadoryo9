require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'json'
require 'koala'
require 'time'
get '/index' do
  require_relative 'fetch_facebook_data.rb'
  @title = "MyApp"
  ACSESS_TORKEN = 'XXXXXXXXXX'.freeze
  APP_SCRET = 'XXXXXXXXXXXXX'.freeze
  class History
    include GetFBData
  end
  my_history = History.new()
  @from_time = Time.parse('2017/01/01')
  @to_time = Time.parse('2018/01/01')
  data_indexs = my_history.getData()
  @range_indexs = my_history.filter(data_indexs,@from_time,@to_time)
  erb :index
end
