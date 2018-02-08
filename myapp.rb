require 'sinatra'
require 'sinatra/reloader'
require 'omniauth-facebook'
require 'net/http'
require 'json'
require 'time'
require 'dotenv'
require 'pp'


Dotenv.load

APP_SECRET = ENV['APP_SECRET']
APP_ID = ENV['APP_ID']

class SinatraOmniAuth < Sinatra::Base
  configure do
    set :sessions, true
    set :inline_templates, true
  end

  use OmniAuth::Builder do
    provider :facebook, APP_ID, APP_SECRET,
    scope: "email, user_birthday, public_profile, user_posts", display: "popup",
    info_fields: "email, birthday, gender, first_name, last_name, posts"
  end

  get '/' do
    @title = 'Tadoryo9'
    erb :top
  end

  get '/auth/:provider/callback' do
    @provider = params[:provider]
    @result = request.env['omniauth.auth']
    ACCESS_TOKEN = @result['credentials']['token']
    redirect '/index'
  end

  get '/index' do
    require_relative 'history.rb'
    @title = 'Tadoryo9'
    @from_time = params[:from_time].nil? ? '2017/01/01' : params[:from_time]
    @to_time = params[:to_time].nil? ? '2018/01/01' : params[:to_time]
    my_history = History.new(ACCESS_TOKEN, APP_SECRET)
    data_indexs = my_history.gets_data
    @range_indexs = my_history.filter_by_date(data_indexs, @from_time, @to_time)
    erb :index
  end
end
SinatraOmniAuth.run! if __FILE__ == $0
