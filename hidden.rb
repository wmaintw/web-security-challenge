get '/find-the-hidden-page.php' do
  session[:token_1] = nil
  erb :find_hidden_page
end

get '/test.php' do
  session[:token_1] = (generate_token CHALLENGE_1) if session[:token_1].nil?
  erb :hidden_page
end
