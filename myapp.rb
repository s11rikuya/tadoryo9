require 'sinatra/reloader'
require 'net/http'
require 'json'
require 'time'
require 'pp'
require 'bundler'
Bundler.require
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
    info_fields: "id, name, email, birthday, gender, first_name, last_name, posts"
  end

  helpers do
    def get_alphabet(n)
      ('A'[0].ord + n).chr
    end
  end

  get '/' do
    session[:access_token] = nil
    erb :top
  end

  get '/auth/:provider/callback' do
    @provider = params[:provider]
    pp @result = request.env['omniauth.auth']
    session[:access_token] = @result['credentials']['token']
    session[:user_id] = @result['extra']['raw_info']['id']
    redirect '/index'
  end

  get '/index' do
    redirect '/' if session[:access_token].nil?
    require_relative 'history.rb'
    session[:since_time] = params[:since_time].nil? || params[:since_time].empty? ? '2017/01/01' : params[:since_time]
    session[:until_time] = params[:until_time].nil? || params[:until_time].empty? ? '2017/02/01' : params[:until_time]
    @since_time = session[:since_time]
    @until_time = session[:until_time]
    @user_id = session[:user_id]
    @range_indexes = []
    @sum_distance = 0
    if File.file?("#{@user_id}.json") && File.file?("#{@user_id}.txt")
      File.delete("#{@user_id}.json")
      File.delete("#{@user_id}.txt")
    end
    EM::defer do
      p 'operation started!'
      my_history = History.new(session[:access_token])
      pp @range_indexes = my_history.gets_data(@since_time, @until_time)
      pp @sum_distance = @range_indexes.empty? ? 0 : my_history.calculation(@range_indexes)
      File.open("#{@user_id}.json","w") do |json|
        json.puts(JSON.generate(@range_indexes))
      end
      File.open("#{@user_id}.txt", "w") do |file|
        file.print(@sum_distance)
      end
      p 'operation finished!'
    end
    erb :index
  end

  get '/reload' do
    redirect '/' if session[:access_token].nil?
    require_relative 'history.rb'
    @since_time = session[:since_time]
    @until_time = session[:until_time]
    @user_id = session[:user_id]
    if File.file?("#{@user_id}.json") && File.file?("#{@user_id}.txt")
      File.open("#{@user_id}.json") do |json|
        pp @range_indexes = JSON.load(json)
      end
      File.open("#{@user_id}.txt") do |file|
        @sum_distance = file.read
      end
    end
    erb :index
  end

  get '/about' do
    erb :about
  end

  error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].message
  end

end
SinatraOmniAuth.run! if __FILE__ == $0
