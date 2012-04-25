#require 'em-http-request'
require 'confstruct'

module Gmusic
  module Download

    class InvalidArgument < ArgumentError; end

    def self.config
      @@config ||= ::Confstruct::Configuration.new do
        concurrency 3
      end
    end

    class Agent
      extend AsyncRequest

      class << self
        def download(*songs)
          raise InvalidArgument, 'must be a song or an array of songs' if songs.empty?

          urls = songs.map(&:url)
          responses = multi_async_get(urls, Download.config.concurrency)
          songs.each { |s| save(s.title, responses[s.url.hash]) }
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

      #def multi_async_requests(songs, concurrency)
      #results = []
      #EM.synchrony do
      #EM::Synchrony::Iterator.new(songs, concurrency).each do |song, iter|
      #http = EventMachine::HttpRequest.new(song.link).aget
      #http.callback { results.push save(song.title, http.response) }
      #http.errback { iter.next }
      #end
      #EventMachine.stop
      #end

      #results
      #end

      #private

      #def save(filename, content)
      #fname = File.join(Gmusic::DEFAULT_DIRECTORY, filename + '.mp3')
      #File.open(fname, 'w+') do |f|
      #begin
      #f.write content
      #ensure
      #f.close
      #end
      #end

      #fname
      #end
    end

  end
end
