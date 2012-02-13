module Gmusic
  class Song
    attr_reader :title, :artist, :link

    def initialize(attrs = {})
      @title = attrs[:title]
      @artist = attrs[:artist]
      @link = attrs[:link]
    end

    class << self
      def search_by_title(title)
        results = Search::Agent.search(title: title)
        # collect_songs
      end
    end
  end
end
