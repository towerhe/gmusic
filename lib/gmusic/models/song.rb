module Gmusic
  class InvalidAttributesError < StandardError; end # :nodoc:

  # = Song Modle
  #
  # The song model release you from messing with the infrastructure, the Search and Download modules.
  # A song contains 3 attributes:
  # * title
  # * artist
  # * url
  #
  # == Examples
  #
  # # search songs
  # title = 'my favorite song title'
  # songs = Song.search_by_title title
  # favorite = songs.first
  #
  # # download it, it will be saved in ~Downloads/gmusic
  # favorite.save
  #
  # # or save in wherever you like
  # favorite.save(path)
  #
  # # download a song directly
  #
  # a song named after it's title will be saved in ~Downloads/gmusic
  # Song.download(title)
  #
  # # or specify with a path
  # Song.download(title, path)
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
