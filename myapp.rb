require 'sinatra'
require 'sinatra/reloader'
require 'omniauth-facebook'
require 'net/http'
require 'json'
require 'time'
require 'dotenv'
require 'pp'
enable :sessions
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
    session[:access_token] = @result['credentials']['token']
    redirect '/index'
  end

  get '/index' do
    redirect '/' if session[:access_token].nil?
    require_relative 'history.rb'
    @title = 'Tadoryo9'
    @since_time = params[:since_time].nil? ? '2017/01/01' : params[:since_time]
    @until_time = params[:until_time].nil? ? '2018/01/01' : params[:until_time]
    my_history = History.new(session[:access_token])
    pp @range_indexs = my_history.filter_by_date(@since_time, @until_time)
    @sum_distance = my_history.culculation(@range_indexs)
    erb :index
  end

  error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].message
  end

end
SinatraOmniAuth.run! if __FILE__ == $0
