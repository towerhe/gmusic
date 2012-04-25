require 'em-http-request'
require 'confstruct'
#require 'gmusic/http/async_request'

module Gmusic
  module Download

    class InvalidArgument < ArgumentError; end

    def self.config
      @@config ||= ::Confstruct::Configuration.new do
        concurrency 3
      end
    end

    class Agent
      #TODO introduce HTTP::AsyncRequest and replace multi_async_requests later
      #extend HTTP::AsyncRequest

      def self.download(*songs)
        raise InvalidArgument, 'must be a song or an array of songs' if songs.empty?

        new.multi_async_requests(songs, Download.config.concurrency)
      end

      def multi_async_requests(songs, concurrency)
        results = []
        EM.synchrony do
          EM::Synchrony::Iterator.new(songs, concurrency).each do |song, iter|
            http = EventMachine::HttpRequest.new(song.link).aget
            http.callback { results.push save(song.title, http.response) }
            http.errback { iter.next }
          end
          EventMachine.stop
        end

        results
      end

      private

      def save(filename, content)
        fname = File.join(Gmusic::DEFAULT_DIRECTORY, filename + '.mp3')
        File.open(fname, 'w+') do |f|
          begin
            f.write content
          ensure
            f.close
          end
        end

        fname
      end
    end

  end
end
