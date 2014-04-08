require 'spec_helper'

describe TwilioEndpoint do
  let(:config)  { { "twilio_account_sid" => 'ABC',
                    "twilio_auth_token" => 'ABC',
                    "twilio_phone_from" => twilio_phone_from,
                    'twilio_address_type' => 'billing' } }

  let(:twilio_phone_from) { '+55123' }
  let(:customer_phone) { '+55321' }
  let(:customer_name)  { 'Pablo' }
  let(:order_number)   { 'RN123456' }
  let(:client)         { double('Twilio client').as_null_object }

  before do
    Twilio::REST::Client.stub(:new).with('ABC', 'ABC').and_return(client)
  end

  context 'when order' do
    let(:order)   { { id: order_number, billing_address: { firstname: customer_name,
                                                               phone: customer_phone } } }
    let(:request) { { request_id: '1234567',
                      order: order,
                      parameters: config } }

    describe '/sms_order' do
      it 'notifies new order' do
        body = "Hey #{customer_name}! Your order #{order_number} has been received."

        expect(client).to receive(:create).
          with(from: twilio_phone_from,
               to: customer_phone,
               body: body)

        post '/sms_order', request.to_json, auth

        expect(last_response).to be_ok
        expect(json_response[:summary]).to eq ("SMS confirmation sent to #{customer_phone}")
      end
    end

    describe '/sms_cancel' do
      it 'notifies canceled order' do
        body = "Hey #{customer_name}! Your order #{order_number} has been canceled."

        expect(client).to receive(:create).
          with(from: twilio_phone_from,
               to: customer_phone,
               body: body)

        post '/sms_cancel', request.to_json, auth

        expect(last_response).to be_ok
        expect(json_response['summary']).to eq ("SMS confirmation sent to #{customer_phone}")
      end
    end
  end

  context 'when shipment' do
    describe '/sms_ship' do
      let(:request)         { { request_id: '1234567',
                                shipment: shipment,
                                parameters: config } }
      let(:shipment_number) { '123' }
      let(:shipment)        { { id: shipment_number,
                                order_id: order_number,
                                shipping_address: { firstname: customer_name,
                                                    phone: customer_phone } } }

      it 'notifies new shipment' do
        body   = "Hey #{customer_name}! Your shipment \##{shipment_number} for order \##{order_number} has shipped."

        expect(client).to receive(:create).
          with(from: twilio_phone_from,
               to: customer_phone,
               body: body)

        post '/sms_ship', request.to_json, auth

        expect(last_response).to be_ok
        expect(json_response['summary']).to eq ("SMS confirmation sent to #{customer_phone}")
      end
    end
  end
end
