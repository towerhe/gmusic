require 'gmusic/search_agent'

module Gmusic

  SEARCH_URL = %Q{http://www.google.cn/music/search?q=}
  DOWNLOAD_URL = %Q(http://www.google.cn/music/top100/musicdownload?id=%s)
  SEARCH_OPTSTIONS = [:title, :artist, :album, :lyric]

  class SearchError < StandardError; end
  class InvalidParameter < SearchError; end
  class NotFound < SearchError; end

end
