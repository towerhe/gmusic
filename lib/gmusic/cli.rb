require 'thor'
require 'gmusic'

module Gmusic
  class CLI < Thor
    argument :option
    desc 'song', 'Search and download songs'
    method_options %w( title -t ) => :string
    def song
      case option
      when 'search'
        results = Song.search_by_title(options[:title].gsub(/-/, ' '))
        reporter = SongReporter.new
        reporter.decorate results
      when 'download'
        puts 'download'
      else
        raise 'invalid action'
      end
    end
  end
end
