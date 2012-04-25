#require 'em-http-request'
require 'em-synchrony'
require 'em-synchrony/em-http'

module Gmusic
  module AsyncRequest

    def multi_async_get(urls, concurrency = 3)
      results = {}

      EM.synchrony do
        EM::Synchrony::Iterator.new(urls, concurrency).each do |url, iter|
          http = EventMachine::HttpRequest.new(url).aget
          http.callback do
            result = block_given? ? yield(http.response) : http.response
            results.merge!(url.hash => result)
            iter.next
          end
          http.errback { iter.next }
        end

        EventMachine.stop
      end

      results
    end

  end
end
