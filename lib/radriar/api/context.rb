module Radriar
  module API
    module Context
      def context
        OpenStruct.new(current_user: current_user)
      end

      def id
        params[:id]
      end

      def create_params
        [permitted_params, create_handlers]
      end

      def create_handlers
        @create_handlers ||= {
          success: ->(record) { represent(record) },
          failure: ->(errors) { error!({
            message: "Validation failed", errors: errors }, 422)
          }
        }
      end

      def update_params
        [id, permitted_params, update_handlers]
      end

      def update_handlers
        @update_handlers ||= {
          success: ->(record) { represent(record) },
          failure: ->(errors) { error!({
            message: "Validation failed",
            errors: errors }, 422)
          }
        }
      end

      def success_or_forbidden_handlers
        @success_of_forbidden_handlers ||= {
          success: ->(*)   { status 200 },
          failure: ->(msg) { error!(msg, 403)}
        }
      end
      alias_method :delete_params, :success_or_forbidden_handlers
    end
  end
end
