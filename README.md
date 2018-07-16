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
      data: {
        id: 'a123b456',
        type: 'users',
        attributes: {
          uid: 'a123b456',
          first_name: 'Jessica',
          last_name: 'Gehring',
          email: 'jgehring@acmeinc.com',
          email_verified: true,
          picture: 'https://d278pcsqxz7fg5.cloudfront.net/.../square-1531756321.jpg',
          picture_medium: 'https://d278pcsqxz7fg5.cloudfront.net/.../medium-1531756321.jpg',
          picture_large: 'https://d278pcsqxz7fg5.cloudfront.net/.../large-1531756321.jpg',
          organization: 'Acme Inc',
          org_role: 'VP Business Development',
          linkedin_url: 'https://www.linkedin.com/in/jgehring',
          twitter_url: 'https://twitter.com/jgehring',
          time_zone: 'America/New_York',
          time_zone_offset: -8,
          created_at: '2017-04-15T10:08:46.499Z'
          updated_at: '2018-11-11T16:22:18.259Z'
        }
      },
      included: [
        {
          id: 5678,
          type: 'locations',
          attributes: {
            name: 'New York, NY',
            google_place_id: 'abc123456789',
            lat: 40.7127753,
            lng: -74.0059728
          }
        },
        {
          id: 55,
          type: 'emails',
          attributes: {
            email: 'jgehring@acmeinc.com',
            primary: true,
            confirmed: true,
            confirmed_at: "2018-07-16T15:52:01.131Z",
            created_at: "2018-07-16T15:52:01.137Z"
          }
        },
        {
          id: 56,
          type: 'emails',
          attributes: {
            email: 'jessica@acmeinc.com',
            primary: false,
            confirmed: true,
            confirmed_at: "2018-07-16T15:52:01.131Z",
            created_at: "2018-07-16T15:52:01.137Z"
          }
        }
      ]
    }
  }
}
```
