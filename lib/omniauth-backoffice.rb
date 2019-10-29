require 'omniauth'

module OmniAuth
  module Strategies
    class Backoffice
      include OmniAuth::Strategy

      option :app_id
      option :secret
      option :backoffice_url
      option :callback_path
      option :info_fields, [:username, :email, :full_name, :root,:user_token]

      def request_phase
        callback_path = options.callback_path
        callback_path = "/" + callback_path unless callback_path[0] == "/"
        callback_url = request.base_url + callback_path
        redirect options.backoffice_url + "/auth/sign_in?redirect_url=#{callback_url}&app_id=#{options.app_id}"
      end

      def callback_phase
        if request.params['denied']
          fail!(request.params['denied'])
        else
          secret = options.secret
          data = "uid=#{uid}&email=#{info[:email]}&username=#{info[:nickname]}&full_name=#{info[:name]}&root=#{extra[:root]}&user_token=#{info[:user_token]}"
          digest = OpenSSL::Digest.new('sha256')
          hmac = OpenSSL::HMAC.hexdigest(digest, secret, data)

          if hmac == request.params['hmac']
            super
          else
            fail!(:hmac)
          end
        end
      end

      uid do
        request.params['uid']
      end
      info do
        info = {}
        info[:name] = request.params['full_name']
        info[:email] = request.params['email']
        info[:nickname] = request.params['username']
        info[:user_token] = request.params['user_token']
        info
      end
      extra do
        extra = {}
        extra[:root] = request.params['root'] == 'true'
        extra
      end
    end
  end
end