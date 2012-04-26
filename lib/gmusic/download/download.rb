require "confstruct"
module Gmusic
  module Download

    class InvalidArgument < ArgumentError; end

    def self.config
      @@config ||= ::Confstruct::Configuration.new do
        concurrency 3
      end
    end

  end
end

