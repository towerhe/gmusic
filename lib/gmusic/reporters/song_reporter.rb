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
          {'歌名' => 20, '歌手' => 20, '链接' => 45}.each { |k, v| column k, width: v, padding: 2 }
        end

        array.each do |song|
          row color: 'green' do
            [:title, :artist, :link].each { |method| column song.send(method) }
          end
        end
      end
    end
  end
end
