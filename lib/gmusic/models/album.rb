module Gmusic
  class Album
    attr_reader :title, :artist, :songs

    def initialize(attrs = {})
      @title = attrs[:title]
      @artist = attrs[:artist]
      @songs = attrs[:songs]
    end

    class << self
      def search_by_title(title)
        results = Search::Agent.search(title: title)
        # collect_the_album
      end
    end
  end
end
