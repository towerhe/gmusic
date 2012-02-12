require 'gmusic/search_agent'

module Gmusic

  class SearchError < StandardError; end
  class InvalidParameter < SearchError; end
  class NotFound < SearchError; end

end
