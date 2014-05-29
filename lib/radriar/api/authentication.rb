module Radriar
  module API
    module Authentication
      def warden
        env['warden']
      end

      def authenticated?
        warden.authenticated? || !find_user
      end

      def authenticate!
        if authenticated?
          current_user.tap { |u| u.try(:seen!)}
        else
          error("401 Unauthorized", 401)
        end
      end
    end

    def current_user
      warden.user || find_user
    end

    def find_user
      token = params[:access_token] || headers['Authorization']
      User.find_for_token_authentication(token)
    end
  end
end
