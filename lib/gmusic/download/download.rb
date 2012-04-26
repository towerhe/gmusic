require "confstruct"
module Gmusic
  module Download
    autoload :SyncAgent, 'gmusic/download/sync_agent'
    autoload :AsyncAgent, 'gmusic/download/async_agent'

    class InvalidArgument < ArgumentError; end

    def self.config
      @@config ||= ::Confstruct::Configuration.new do
        concurrency 3
      end
    end

  end
end

