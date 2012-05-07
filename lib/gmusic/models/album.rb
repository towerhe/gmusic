module Gmusic
  class Album
    attr_accessor :title, :artist, :songs, :url

    def initialize(attrs = {})
      @title = attrs[:title]
      @url = attrs[:url]
      @artist = attrs[:artist]
      @songs = attrs[:songs]
    end

    def download(*ids)
      ids.flatten!
      targets = ids.empty? ? songs : ids.map { |i| songs[i] }

      Download::SyncAgent.download targets
    end

    class << self
      def search(opts)
        Search::Engine.instance.search_album(opts) unless opts.empty?
      end
    end
  end
end
