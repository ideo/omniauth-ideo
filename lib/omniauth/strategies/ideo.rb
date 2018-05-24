require 'omniauth-oauth2'

# This is the definition to auth with the IDEO SSO Network

module OmniAuth
  module Strategies
    class Ideo < OmniAuth::Strategies::OAuth2
      option :name, :ideo

      option :client_options, {
        site: ENV.fetch('IDEO_SSO_HOST', 'https://profile.ideo.com'),
        authorize_url: ENV.fetch('IDEO_SSO_AUTH_PATH', '/oauth/authorize')
      }

      uid { user_data['uid'] }

      info do
        {
          email: user_data['email'],
          first_name: user_data['first_name'],
          last_name: user_data['last_name'],
          picture: user_data['picture'],
          email_verified: user_data['email_verified'] 
        }
      end

      extra do
        {
          'raw_info' => user_data
        }
      end

      def user_data
        return {} if raw_info['data'].blank? ||
                     raw_info['data']['attributes'].blank?
        raw_info['data']['attributes']
      end

      def raw_info
        @raw_info ||= JSON.parse(access_token.get(user_info_url).body)
      end

      def user_info_url
        uri = URI.join(
          ENV.fetch('IDEO_SSO_HOST', 'https://profile.ideo.com'),
          '/api/v1/users/me.json'
        ).to_s
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
