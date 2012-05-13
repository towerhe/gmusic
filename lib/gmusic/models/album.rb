module Gmusic
  class Album
    attr_accessor :title, :artist, :songs, :url

    def initialize(attrs = {})
      @title = attrs[:title]
      @url = attrs[:url]
      @artist = attrs[:artist]
      @songs = attrs[:songs]
    end

    # Returns the directory or an array of failures' title
    def download(*ids)
      ids.flatten!
      targets = ids.empty? ? songs : ids.map { |i| songs[i] }

      Download::SyncAgent.download targets
    end

    class << self
      def search(opts)
        Gmusic.search_engine.search_album(opts) unless opts.empty?
      end
    end
  end
end
