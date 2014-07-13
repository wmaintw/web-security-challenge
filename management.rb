
get '/management/login' do
  erb :management_login
end

post '/management/login' do
  if (params[:username].eql? "admin") && (params[:password].eql? "64072011")
    session[:token_6] = (generate_token CHALLENGE_6) if session[:token_6].nil?
    erb :management_login, :locals => {:success => true}
  else
    erb :management_login, :locals => {:success => nil}
  end
end

get '/management/about' do
  erb :under_construction
end

get '/management/contact' do
  erb :contact
end

get '/management/privacy' do
  erb :under_construction
end