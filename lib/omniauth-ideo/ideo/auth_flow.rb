module OmniAuth
  module Ideo
    module AuthFlow
      def self.populate_omniauth_state_from_cookie
        lambda do |env|
          request = Rack::Request.new(env)
          request.session['omniauth.state'] = request.cookies['IdeoSSO-State']
        end
      end
    end
  end
end
