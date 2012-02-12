module Gmusic
  class Result
    attr_reader :info, :links
    def initialize(info, links)
      @info = info
      @links = links
    end
  end
end
