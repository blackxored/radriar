require 'representable'
module Radriar
  module Roar
    module KeyTranslation
      extend ActiveSupport::Concern

      included do
        unless ::Representable::Hash.instance_methods.include?(:__radriar_old_to_hash)
          ::Representable::Hash.module_eval do
            # TODO: Module#prepend giving too much headache
            alias_method :__radriar_old_to_hash,   :to_hash
            alias_method :__radriar_old_from_hash, :from_hash

            define_method(:from_hash) do |data, options={}, binding_builder=::Representable::Hash::PropertyBinding|
              if Radriar::Representable.translate_keys?
                data = filter_wrap(UnderscoreKeys.new(data), options)
                update_properties_from(data, options, binding_builder)
              else
                __radriar_old_from_hash(data, options, binding_builder)
              end
            end

            define_method(:to_hash) do |options={}, binding_builder=::Representable::Hash::PropertyBinding|
              if Radriar::Representable.translate_keys?
                CamelizeKeys.new(__radriar_old_to_hash(options, binding_builder))
              else
                __radriar_old_to_hash(options, binding_builder)
              end
            end
          end
        end

        unless ::Grape::Endpoint.instance_methods.include?(:__radriar_old_params)
          ::Grape::Endpoint.class_eval do
            alias_method :__radriar_old_params, :params

            define_method(:params) do
              if Radriar::Representable.translate_keys?
                @params ||= UnderscoreKeys.new(@request.params)
              else
                __radriar_old_params
              end
            end
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
          key.to_s.start_with?("_") ? key.to_s : key.to_s.camelize(:lower)
        end
      end
    end
  end
end
