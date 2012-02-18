module Gmusic
  autoload :Song, 'gmusic/models/song'
  autoload :Artist, 'gmusic/models/artist'
  autoload :Album, 'gmusic/models/album'
  autoload :Link, 'gmusic/models/link'
  autoload :SongReporter, 'gmusic/reporters/song_reporter'

  module Search
    autoload :Agent, 'gmusic/search/agent'

    SEARCH_URL = %Q{http://www.google.cn/music/search?q=}
    DOWNLOAD_URL = %Q(http://www.google.cn/music/top100/musicdownload?id=%s)
    SEARCH_OPTSTIONS = [:title, :artist, :album, :lyric]
  end

end
