module Gmusic

  module Search
    autoload :Agent, 'gmusic/search/agent'
    SEARCH_URL = %Q{http://www.google.cn/music/search?q=}
    DOWNLOAD_URL = %Q(http://www.google.cn/music/top100/musicdownload?id=%s)
    SEARCH_OPTSTIONS = [:title, :artist, :album, :lyric]
  end

end
