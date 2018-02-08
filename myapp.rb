require 'sinatra'
require 'sinatra/reloader'
require 'omniauth-facebook'
require 'net/http'
require 'json'
require 'time'
require 'dotenv'
require 'pp'
Dotenv.load

# ACCESS_TOKEN = ENV['ACCESS_TOKEN']
APP_SECRET = ENV['APP_SECRET']
APP_ID = ENV['APP_ID']
# FROM_TIME = '2015/01/01'.freeze
# TO_TIME = '2018/10/01'.freeze

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
    require_relative 'fetch_facebook_data.rb'
    @title = 'Tadoryo9'

    if params[:from_time] && params[:to_time]
      @ftime = params[:from_time]
      @ttime = params[:to_time]
    else
      @ftime = '2017/01/01'
      @ttime = '2018/01/01'
    end

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
    my_history = History.new(ACCESS_TOKEN, APP_SECRET, @ftime, @ttime)
    data_indexs = my_history.gets_data
    @from_time = my_history.from_time
    @to_time = my_history.to_time
    @range_indexs = my_history.filter(data_indexs)
    erb :index
  end
end
SinatraOmniAuth.run! if __FILE__ == $0
