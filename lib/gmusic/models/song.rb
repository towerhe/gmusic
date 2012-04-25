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
      Search::Engine.instance.download(self, dir)
    end

    class << self
      def search_by_title(title)
        begin
          result = Search::Engine.instance.search(title: title) unless title.empty?
        rescue Search::NotFound
          return []
        end

        collect_songs(result)
      end

      def download(title, dir = nil)
        songs = search_by_title(title)
        return false if songs.empty?

        songs.first.save(dir)
      end

      private

      def collect_songs(search_result)
        search_result.details.map { |detail| Song.new(detail) }
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
