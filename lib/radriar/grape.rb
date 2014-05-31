require "radriar/api/authentication"
require "radriar/api/context"
require "radriar/api/exception_handling"
require "radriar/api/logging"
require "radriar/api/strong_parameters_support"

module Radriar
  module Grape
  end
end

class ::Grape::API
  def self.radriarize(hypermedia: false, representer_namespace: nil, translate_keys: false)
    class_eval do
      format :json
      default_format :json

      helpers Radriar::API::Authentication
      helpers Radriar::API::Logging
      helpers Radriar::API::Context
      helpers Radriar::API::StrongParametersSupport
      helpers Radriar::Roar::Representers
      include Radriar::Roar::KeyTranslation
      include Radriar::Roar::HAL

      Radriar::Representable.representer_namespace = representer_namespace
      Radriar::Representable.hypermedia = hypermedia
      Radriar::Representable.translate_keys = translate_keys
    end
  end
end
