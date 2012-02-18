# encoding: UTF-8
require "command_line_reporter"

module Gmusic
  class SongReporter
    include CommandLineReporter

    alias old_header header

    def inilitialize(formatter = :progress)
      self.formatter = formatter.to_s
    end

    def header(title)
      old_header(title: title, color: 'green', align: 'center', rule: true, bold: true)
    end

    def decorate(array)
      header('搜索中...')
      table border: true do
        row color: 'red', bold: true do
          column '歌名', width: 20, padding: 2
          column '歌手', width: 20, padding: 2
          column '链接', width: 45, padding: 2
        end

        array.each do |song|
          row color: 'green' do
            column song.title
            column song.artist
            column song.link
          end
        end
      end
    end
  end
end
