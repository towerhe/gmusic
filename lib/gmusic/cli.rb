require 'thor'
require 'gmusic'

module Gmusic
  class CLI < Thor
    map '-s' => :search

    desc 'search', 'Search songs or albums'
    method_options %w( title -t ) => :string, %w( album -a ) => :string
    def search
      puts SearchAgent.search(options).inspect
    end
  end
end
