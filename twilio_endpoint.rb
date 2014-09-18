require 'sinatra'
require 'endpoint_base'

Dir['./lib/**/*.rb'].each &method(:require)

class TwilioEndpoint < EndpointBase::Sinatra::Base
  set :logging, true
  set :show_exceptions, false

  error do
    result 500, env['sinatra.error'].message
  end

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post '/send_sms' do
    body    = @payload['sms']['message']
    phone   = @payload['sms']['phone']
    from    = @payload['sms']['from']

    message = Message.new(@config, body, phone, from)
    message.deliver

    result 200, %{SMS "#{body}" sent to #{phone}}
  end
end
