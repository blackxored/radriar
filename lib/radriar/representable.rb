module Radriar
  module Representable
    mattr_accessor :representer_namespace
    mattr_accessor :hypermedia

    def self.hypermedia?
      !!hypermedia
    end
  end
end

require "representable/hash"
require "roar/representer/json/hal"
require "radriar/roar/links"
require "radriar/roar/representers"
require "radriar/roar/key_translation"
require "radriar/roar/hal"
