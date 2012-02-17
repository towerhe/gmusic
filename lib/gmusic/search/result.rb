module Gmusic
  module Search
    class Result
      attr_reader :info, :details

      def initialize(info, details)
        @info = info
        #@links = links
        @details = details
      end
    end
  end
end
