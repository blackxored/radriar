module Radriar
  module Representable
    mattr_accessor :representer_namespace

    [:hypermedia, :translate_keys].each do |option|
      mattr_accessor option.to_sym

      self.define_singleton_method "#{option}?".to_sym do
        !!send(option.to_sym)
      end
    end
  end
end

require "representable/hash"
require "roar/representer/json/hal"
require "radriar/roar/links"
require "radriar/roar/representers"
require "radriar/roar/key_translation"
require "radriar/roar/hal"
