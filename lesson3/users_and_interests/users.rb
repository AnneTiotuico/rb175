require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require 'yaml'
USER_INFO = YAML.load_file('users.yml')

before do 
   @users = []
   USER_INFO.each_key do |key|
      @users << key.to_s
   end
end

helpers do
   def count_interests
      total_interests = 0
      users = USER_INFO.each_key.count
      USER_INFO.each_key do |user|
         total_interests += USER_INFO[user.to_sym][:interests].count
      end
      "There are #{users} users with a total of #{total_interests} interests."
   end
end

get '/' do
   @title = "User List"
   
   erb :home
end

get '/users/:user' do
   @user =  params[:user]
   @title = @user.capitalize
   @email = USER_INFO[@user.to_sym][:email]
   @interests = USER_INFO[@user.to_sym][:interests]

   erb :user_page
end


