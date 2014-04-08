require "sinatra"
require "endpoint_base"

Dir['./lib/**/*.rb'].each &method(:require)

class TwilioEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/sms_order' do
    begin
      code   = 200
      order  = Order.new(@config, @payload['order'])
      client = Twilio::REST::Client.new(@config['twilio.account_sid'], @config['twilio.auth_token'])
      body   = "Hey #{order.customer_name}! Your order #{order.number} has been received."

      set_summary "SMS confirmation sent to #{order.customer_phone}"

      message = Message.new(@config, body, order.customer_phone)
      message.deliver
    rescue => e
      code = 500
      set_summary "#{e.inspect} - #{e.backtrace}"
    end
    process_result code
  end

  post '/sms_ship' do
    begin
      code     = 200
      shipment = @payload['shipment']['number']
      order    = @payload['shipment']['order_number']
      name     = @payload['shipment']['shipping_address']['firstname']
      phone    = @payload['shipment']['shipping_address']['phone']
      client   = Twilio::REST::Client.new(@config['twilio.account_sid'], @config['twilio.auth_token'])
      body     = "Hey #{name}! Your shipment \##{shipment} for order \##{order} has shipped."

      set_summary "SMS confirmation sent to #{phone}"

      message = Message.new(@config, body, phone)
      message.deliver
    rescue => e
      code = 500
      set_summary "#{e.inspect} - #{e.backtrace}"
    end
    process_result code
  end

  post '/sms_cancel' do
    begin
      code   = 200
      order  = Order.new(@config, @payload['order'])
      client = Twilio::REST::Client.new(@config['twilio.account_sid'], @config['twilio.auth_token'])
      body   = "Hey #{order.customer_name}! Your order #{order.number} has been canceled."

      set_summary "SMS confirmation sent to #{order.customer_phone}"

      message = Message.new(@config, body, order.customer_phone)
      message.deliver
    rescue => e
      code = 500
      set_summary "#{e.inspect} - #{e.backtrace}"
    end
    process_result code
  end
end
