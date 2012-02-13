module Gmusic
  module Search
    class SearchError < StandardError; end
    class InvalidParameter < SearchError; end
    class NotFound < SearchError; end
  end
end
