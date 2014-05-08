# Twillio Integration for Spree Commerce Hub

Provides a *Send SMS* webhook to be used in Flows.

## Usage

You will need a Twilio account. Trial accounts are pretty easy and quick to
setup up. Visit https://www.twilio.com/ for more info.

Once you have your account grab your *SID* and *Auth token*, they should be right
on the dashboard page. Twilio will also provide a *phone number*.

Create a Flow using Twilio, you can pick any object. We'll pick Order in this case:
![](http://cl.ly/image/2u3d443o1n3t/Screen%20Shot%202014-05-08%20at%2012.14.19%20PM.png)

Now add a transform that extracts objects data into the [SMS format](http://spreecommerce.com/docs/hub/communication_webhooks.html):

```json
{
    "sms":{
        "from":"TWILIO_NUMBER",
        "message": "Thank you! Your order {{order.id}} has been placed.",
        "phone":"{{order.shipping_address.phone}}"
    }
}
```

And you're done! For every new order created event a sms will be sent to the user.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

