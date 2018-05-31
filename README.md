# OmniAuth Ideo

Ideo OAuth2 Strategy for OmniAuth.

Supports OAuth 2.0 server-side and client-side flows, for authenticating with `profile.ideo.com`. See the IDEO SSO docs for more details.

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-ideo', git: 'https://github.com/ideo/omniauth-ideo.git'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::Ideo` is simply a Rack middleware. Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails/Devise app in `config/initializers/devise.rb`:

```ruby
Devise.setup do |config|
  ...
  config.omniauth :ideo, ENV['IDEO_SSO_CLIENT_ID'], ENV['IDEO_SSO_CLIENT_SECRET'], {
    # This setup proc is necessary to store the JS SSO SDK's "state" param,
    # which is validated when receiving an authentication response
    # (otherwise you get csrf token errors)
    setup: OmniAuth::Ideo::AuthFlow.populate_omniauth_state_from_cookie
  }
end
```

## Auth Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

```ruby
{
  provider: 'ideo',
  uid: '1234567',
  info: {
    email: 'jgehring@acmeinc.com',
    first_name: 'Jessica',
    last_name: 'Gehring',
    picture: 'https://d3none3dlnlrde.cloudfront.net/assets/abc123/square-1523036162.jpg',
    email_verified: true
  },
  credentials: {
    token: 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
    refresh_token: 'ABCDEF...', # Use the refresh token to get a new token if it expires
    expires_at: 1321747205, # when the access token expires (it always will)
    expires: true # this will always be true
  },
  extra: {
    raw_info: {
      uid: 'a123b456',
      first_name: 'Jessica',
      last_name: 'Gehring',
      email: 'jgehring@acmeinc.com',
      email_verified: true,
      organization: 'Acme Inc',
      org_role: 'VP Business Development',
      linkedin_url: 'https://www.linkedin.com/in/jgehring',
      twitter_url: 'https://twitter.com/jgehring',
      location: {
        name: 'New York, NY',
        google_place_id: 'abc123456789',
        lat: 40.7127753,
        lng: -74.0059728
      },
      time_zone: 'America/New_York',
      time_zone_offset: -8,
      updated_at: '2011-11-11T06:21:03+0000'
    }
  }
}
```
