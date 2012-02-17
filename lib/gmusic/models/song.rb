module Gmusic
  class InvalidAttributesError < StandardError; end

  class Song
    attr_reader :title, :artist, :link

    def initialize(attrs = {})
      raise(InvalidAttributesError, 'only title, artist and link is allowed') if attrs_invalid?(attrs)

      @title = attrs[:title]
      @artist = attrs[:artist]
      @link = attrs[:link]
    end

    class << self
      def search_by_title(title)
        begin
          result = Search::Agent.search(title: title) unless title.empty?
        rescue Search::NotFound
          return []
        end

        collect_songs(result)
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
        return true unless [:title, :artist, :link].include? key
      end

      false
    end
  end
end
