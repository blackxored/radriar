module Radriar
  module API
    module StrongParametersSupport
      def permitted_params
        declared(params, include_missing: false)
      end
    end
  end
end
