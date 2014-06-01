module Radriar
  module Roar
    module HAL
      extend ActiveSupport::Concern

      included do
        module ::Roar::Representer::JSON::HAL::Resources
          def compile_fragment(bin, doc)
            embedded = bin[:embedded]
            return super unless embedded
            if Radriar::Representable.hypermedia?
              super(bin, doc['_embedded'] ||= {})
            else
              super
            end
          end
        end
      end
    end
  end
end
