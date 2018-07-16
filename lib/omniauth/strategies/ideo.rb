require 'omniauth-ideo'

# This is the definition to auth with the IDEO SSO Network

module OmniAuth
  module Strategies
    class Ideo < OmniAuth::Strategies::OAuth2
      option :name, :ideo

      option :client_options, {
        site: ENV.fetch('IDEO_SSO_HOST', 'https://profile.ideo.com'),
        authorize_url: ENV.fetch('IDEO_SSO_AUTH_PATH', '/oauth/authorize')
      }

      uid { user_attributes['uid'] }

      info do
        {
          username: user_attributes['username'],
          first_name: user_attributes['first_name'],
          last_name: user_attributes['last_name'],
          picture: user_attributes['picture'],
          email: user_attributes['email'],
          email_verified: user_attributes['email_verified'],
          emails: emails
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def user_attributes
        return {} if raw_info['data'].blank? ||
                     raw_info['data']['attributes'].blank?
        raw_info['data']['attributes']
      end

      def emails
        raw_info['included']
        .select { |obj| obj['type'] === 'emails' }
        .map { |email| email['attributes'] }
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
