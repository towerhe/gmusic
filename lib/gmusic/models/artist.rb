module Gmusic
  class Artist
    attr_reader :name, :has_songs

    def initialize(attrs = {})
      @name = attrs[:name]
      @hot_songs = attrs[:hot_songs]
    end

    class << self
      def search_by_name(name)
        results = Search::Agent.search(aritst: name)
        # TODO initialize the artist
      end
    end
  end
end
