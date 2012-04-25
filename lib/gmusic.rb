module Gmusic
  autoload :Song, 'gmusic/models/song'
  autoload :Artist, 'gmusic/models/artist'
  autoload :Album, 'gmusic/models/album'
  autoload :Link, 'gmusic/models/link'
  #autoload :CLI, 'gmusic/cli/cli'
  #autoload :CLIReporter, 'gmusic/reporters/cli_reporter'
  #autoload :SongReporter, 'gmusic/reporters/song_reporter'
  #autoload :AlbumReporter, 'gmusic/reporters/album_reporter'
  autoload :Download, 'gmusic/download/agent'
  autoload :AsyncRequest, 'gmusic/http/async_request'

  module Search
    autoload :Engine, 'gmusic/search/engine'
    autoload :Result, 'gmusic/search/result'

    SEARCH_URL = %Q(http://www.google.cn/music/search?q=)
    ALBUM_URL = %Q(http://www.google.cn/music/album?id=)
    DOWNLOAD_URL = %Q(http://www.google.cn/music/top100/musicdownload?id=%s)
    SEARCH_OPTSTIONS = [:title, :artist, :album, :lyric]
    DEFAULT_DIRECTORY = File.expand_path '~/Downloads'
  end

end
