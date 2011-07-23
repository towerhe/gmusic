require 'rubygems'
require 'bundler/setup'

require 'hpricot'
require 'open-uri'

require 'gmusic/parser'

module GMusic
  class << self
    VALID_CONDITIONS = [ :title, :artist ]

    SEARCH_URL_TEMPLATE = %Q(http://www.google.cn/music/search?q=%s&aq=f)
    DOWNLOAD_INFO_URL_TEMPLATE = %Q(http://www.google.cn/music/top100/musicdownload?id=%s)
    LYRICS_URL_TEMPLATE = %Q(http://www.google.cn/music/top100/lyrics?id=%s)


    def search(conditions)
      validate_conditions(conditions)
      query = construct_query(conditions)
      songs = SongListParser.parse(SEARCH_URL_TEMPLATE % query)
      
      matched = []
      songs.each do |song|
        if matched?(song, conditions)
          song.merge!(DownloadInfoParser.parse(DOWNLOAD_INFO_URL_TEMPLATE % song[:id]))
          song.merge!(LyricsParser.parse(LYRICS_URL_TEMPLATE % song[:id])) 
          matched << song
        end
      end
      matched
    end

    private 
    def validate_conditions(conditions)
      raise_argument_error if conditions.empty? or (conditions.keys & VALID_CONDITIONS).empty?
    end

    def construct_query(conditions)
      query = ''
      VALID_CONDITIONS.each do |c|
        query << (query.empty? ? '' : '+') << "\"#{conditions[c]}\"" if conditions.has_key? c
      end
      URI.escape query
    end

    def raise_argument_error
      raise ArgumentError.new('must specify at least one condition')
    end

    def matched?(result, conditions)
      if conditions.has_key?(:title) and not result[:title].downcase.eql?(conditions[:title].downcase)
        return false
      end
      if conditions.has_key?(:artist) and not result[:artist].downcase.include?(conditions[:artist].downcase)
        return false
      end
      return true
    end
  end
end
