#require 'gmusic/reporters/cli_reporter'

module Gmusic
  class AlbumReporter
    include CLIReporter

    def self.decorate(&block)
      new.tap do |r|
        r.header 'Searching'
        r.subject = block.call
        r.list r.subject
      end
    end

  end
end
