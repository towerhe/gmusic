require "command_line_reporter"

module Gmusic
  class SongReporter
    include CommandLineReporter

    alias old_header header

    def inilitialize(formatter = :progress)
      self.formatter = formatter
    end

    def header(title)
      old_header(title: title, color: 'green', width: 80, alain: 'center', rule: true, blod: true)
    end
  end
end
