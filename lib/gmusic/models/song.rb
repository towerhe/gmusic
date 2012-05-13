module Gmusic
  class InvalidAttributesError < StandardError; end

  class Song
    attr_reader :title, :artist, :url

    def initialize(attrs = {})
      raise(InvalidAttributesError, 'only title, artist and url is allowed') if attrs_invalid?(attrs)

      @title = attrs[:title]
      @artist = attrs[:artist]
      @url = attrs[:url]
    end

    def save(dir = nil)
      Gmusic.search_engine.download(self, dir)
    end

    class << self
      def search_by_title(title)
        begin
          Gmusic.search_engine.search_song(title: title) unless title.empty?
        rescue Search::NotFound
          return []
        end
      end

      def download(title, dir = nil)
        songs = search_by_title(title)
        return false if songs.empty?

        songs.first.save(dir)
      end
    end

    private

    def attrs_invalid?(attrs)
      return true if attrs.size != 3
      attrs.each_key do |key|
        return true unless [:title, :artist, :url].include? key
      end

      false
    end
  end
end
