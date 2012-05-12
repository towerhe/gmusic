require 'em-http-request'
require 'em-synchrony'
require 'em-synchrony/em-http'

module Gmusic
  # = AsyncRequest

  # This module is powered by {EventMachine}[https://github.com/eventmachine/eventmachine] and {em-http-request}[https://github.com/igrigorik/em-http-request] and {em-synchrony}[https://github.com/igrigorik/em-synchrony].
  # By taking advantage of EventMacine, it allows you to issue parallel requests. You can easily control concurrency and follow redirects.
  #
  # Examples:
  #
  #   class Klass
  #     include AsyncRequest
  #
  #     def parallel_requests(urls)
  #       responses = multi_async_get urls
  #
  #       urls.each do |url|
  #         puts url
  #         puts responses[url] # NOTE it take the url as a key
  #       end
  #     end
  #
  #     # Note that you can also control concurrency.
  #     # Say you have 10 requests to make, but you only want to have
  #     # at most 5 in progress at any given point.
  #     # You can simply spully a second argument, a integer to config the concurrency, default is 3.
  #     def parallel_request_with_concurrency(urls, concurrency)
  #       multi_async_get urls, concurrency
  #       ...
  #     end
  #
  #     # It don't follow redirects by default, but you can if necessary.
  #     def parallel_request_with_concurrency_and_follow_redirects(urls, concurrency, redirects)
  #       multi_async_get urls, concurrency, redirects
  #       ...
  #     end
  #
  #     # Sometime you'd like to deal with the responses, you can supply a to block.
  #     # Say you like to extract some info from the page.
  #     def parallel_request_with_block(urls)
  #       info = multi_async_get(urls) do |http|
  #         page = Nokogiri::HTML http.response
  #         ...
  #       end
  #
  #       urls.each do |url|
  #         puts url
  #         puts info[url.hash]
  #       end
  #     end
  #   end
  #

  module AsyncRequest

    # Make multiple asynchronous get requests
    #
    # Arguments:
    #   urls: (Array)
    #   concurrency: (Integer)
    #   redirects: (Integer)
    #
    # Returns a hash, keys are hash code of the urls, values are responses.

    def multi_async_get(urls, concurrency = 3, redirects = 0) # if block given, :yields: http
      results = {}

      EM.synchrony do
        EM::Synchrony::Iterator.new(urls, concurrency).each do |url, iter|
          opts = { inactivity_timeout: 0, redirects: redirects }
          http = EventMachine::HttpRequest.new(url).aget(opts)

          http.callback do
            result = block_given? ? yield(http) : http.response
            results.merge!(url => result)
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
