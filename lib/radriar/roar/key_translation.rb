require 'representable'
module Radriar
  module Roar
    module KeyTranslation
      extend ActiveSupport::Concern

      included do
        ::Representable::Hash.module_eval do
          # TODO: Module#prepend giving too much headache
          alias_method :old_to_hash, :to_hash
          define_method(:from_hash) do |data, options={}, binding_builder=::Representable::Hash::PropertyBinding|
            data = filter_wrap(UnderscoreKeys.new(data), options)
            update_properties_from(data, options, binding_builder)
          end

          define_method(:to_hash) do |options={}, binding_builder=::Representable::Hash::PropertyBinding|
            CamelizeKeys.new(old_to_hash(options, binding_builder))
          end
        end

        ::Grape::Endpoint.class_eval do
          define_method(:params) do
            @params ||= UnderscoreKeys.new(@request.params)
          end
        end
      end

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
    end
  end
end
