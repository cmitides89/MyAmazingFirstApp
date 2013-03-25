require 'twilio-ruby'
require 'sinatra'
require 'rack-flash'

enable :sessions
set :session_secret, 'super secret'
use Rack::Flash

get '/' do
  erb :index
end

post '/submit' do
  @message = "Someone thought your cupcakes were #{params[:answer]}"
  
  # Change these to match your Twilio account settings 
  @account_sid = "ACf8e98f3fd96dbe29d0588dfcfa1b673d"
  @auth_token = "73d0ca498d29a3143ce99c8cab050d09"
  
  # Set up a client to talk to the Twilio REST API
  @client = Twilio::REST::Client.new(@account_sid, @auth_token)
    
  @account = @client.account
  @sms = @account.sms.messages.create({
    :from => '+16464614467', 
    :to => '+19174968239',
    :body => @message
  })
  
  flash[:notice] = "SMS sent: #{@message}"
  redirect '/'
end
