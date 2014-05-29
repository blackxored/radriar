require 'representable'
module Radriar
  module Roar
    module KeyTranslation
      extend ActiveSupport::Concern

      class KeyTranslatorHash < Hashie::Mash
        protected
        def convert_key(key)
        end

        def convert_value(val, duping=false) #:nodoc
          obj = super
          obj = self.class.new(obj) if Hashie::Mash === obj
          obj if Hashie::Mash === obj
          obj
        end

        def initialize_reader(key)
          ck = to_underscore(key)
          custom_writer(ck, self.class.new) unless key?(ck)
          custom_reader(ck.camelize)
        end
      end

      class UnderscoreKeys < KeyTranslatorHash
        protected
        def convert_key(key)
          key.to_s.underscore
        end
      end

      class CamelizeKeys < KeyTranslatorHash
        protected
        def convert_key(key)
          key.to_s.camelize(:lower)
        end
      end


      module Representer
        def from_hash(data, options={}, binding_builder=::Representable::Hash::PropertyBinding)
          data = filter_wrap(UnderscoreKeys.new(data), options)
          update_properties_from(data, options, binding_builder)
        end

        def to_hash(options={}, binding_builder=::Representable::Hash::PropertyBinding)
          CamelizeKeys.new(super)
        end
      end
      
      included do
        ::Representable::Hash.prepend(Representer)
      end
    end
  end
end
