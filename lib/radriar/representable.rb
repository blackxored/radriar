module Radriar
  module Representable
    mattr_accessor :representer_namespace
    mattr_accessor :hypermedia

    def self.hypermedia?
      !!hypermedia
    end
  end
end

require "radriar/roar/links"
require "radriar/roar/representers"
