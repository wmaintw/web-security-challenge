require 'sinatra'
require 'erubis'

require './injection'
require './admin_login'
require './search'
require './management'
require './hidden'

require 'net/http'

enable :sessions

set :bind, "0.0.0.0"

CHALLENGE_1 = 1
CHALLENGE_2 = 2
CHALLENGE_3 = 3
CHALLENGE_4 = 4
CHALLENGE_5 = 5
CHALLENGE_6 = 6

get '/' do
  erb :challenges
end

get '/customer/login' do
  erb :login
end

def generate_token challenge_index
  token = SecureRandom.hex(8)

  begin
    Net::HTTP.get(URI("http://localhost:9000/score/token?token=#{token}&index=#{challenge_index}&key=705"))
  rescue Exception => e
    p "Failed to register token. #{e}"
  end

  token
end

post '/customer/login' do
  if (injection_login?(params[:username], params[:password]))
    session[:message] = nil
    session[:auth_status] = "logged in"

    session[:token_2] = (generate_token CHALLENGE_2) if session[:token_2].nil?

    redirect "/customer/dashboard"
  else
    if (normal_login?(params[:username], params[:password]))
      session[:tom_auth_status] = "logged in"
      redirect "/customer/myProfile"
    else
      session[:message] = "Invalid username or password"
      redirect "/customer/login"
    end
  end
end

get '/customer/dashboard' do
  redirect '/customer/login' if session[:auth_status].nil?
  erb :dashboard
end

get '/customer/myProfile' do
  redirect '/customer/login' if session[:tom_auth_status].nil?
  erb :profile, :locals => {:name => "Tom Cat", :role => "Developer"}
end

post '/customer/myProfile' do
  if (!params[:uid].nil?) && (!params[:uid].eql?("47290"))
    session[:token_5] = (generate_token CHALLENGE_5) if session[:token_5].nil?
    erb :profile, :locals => {:success => true, :name => "Jerry", :role => "QA"}
  else
    erb :profile, :locals => {:message => "Profile refreshed at #{Time.now}", :name => "Tom Cat", :role => "Developer"}
  end
end

get '/customer/logout' do
  session[:auth_status] = nil
  session[:tom_auth_status] = nil
  session[:token_2] = nil
  session[:token_5] = nil

  redirect '/customer/login'
end

get '/reset' do
  session[:auth_status] = nil
  session[:tom_auth_status] = nil
  session[:token_1] = nil
  session[:token_2] = nil
  session[:token_3] = nil
  session[:token_4] = nil
  session[:token_5] = nil
  session[:token_6] = nil

  redirect '/'
end


def normal_login? usr, pwd
  usr.eql?("tom") && pwd.eql?("cat")
end

not_found do
  'Oops, 404! Page Not Found'
end

error do
  'Sorry, an error was happen.'
end