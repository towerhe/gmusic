module Gmusic
  # = Album Model
  #
  # A album have 4 attributes:
  # * title
  # * artist
  # * songs -- A array of Song object
  # * url
  #
  # == Examples
  #
  # # search an album
  # options = { title: 'my favorite album', artist: 'my favorite artist' }
  # albums = Album.search options
  # favorite = albums.first
  # favorite.songs.each_with_index do |song, i|
  #   puts i, song.title, song.artist
  # end
  #
  # # download one of your favorite songs
  # song = favorite.songs.first
  # song.save
  #
  # # or download some by passing indexes of the songs you like
  # favorite.download(1, 2, 3)
  #
  # # or download the whole album
  # favorite.download
  #
  # # Songs download will be saved in ~Downloads
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
