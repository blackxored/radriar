module Radriar
  module Bugsnag
    module UserInfo
      extend ActiveSupport::Concern
      included do
        before do
          ::Bugsnag.before_notify_callbacks << ->(notif) do
            if current_user
              notif.add_tab(:user, {
                id:           current_user.id,
                username:     current_user.username,
                ip:           notif.user_id
              })
            end
          end
        end

        after do
          Bugsnag.before_notify_callbacks.clear
        end
      end
    end
  end
end
