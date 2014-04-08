class Message
  def initialize(config, message_text, phone_number)
    @client = Twilio::REST::Client.new(config['twilio_account_sid'], config['twilio_auth_token'])
    @config = config
    @message_text = message_text
    @phone_number = phone_number
  end

  def deliver
    @client.account.messages.create(
      from:   @config['twilio_phone_from'],
      to:     @phone_number,
      body:   @message_text
    )
  end
end
