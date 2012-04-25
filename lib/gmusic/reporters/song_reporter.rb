# encoding: UTF-8
require "command_line_reporter"

module Gmusic
  class SongReporter
    include CommandLineReporter

    attr_accessor :subject

    def inilitialize(formatter = :progress)
      self.formatter = formatter.to_s
    end

    def header(title)
      super(title: title, color: 'green',
            align: 'center', rule: true,
            bold: true)
    end

    def list(array)
      table border: true do
        thead = { id: 10, title: 20, artist: 20, url: 45 }

        row color: 'red', bold: true do
          thead.each { |k, v| column k, width: v, padding: 2 }
        end

        array.each_with_index do |item, index|
          row color: 'green' do
            column (index + 1).to_s
            thead.shift
            thead.each_key { |method| column item.send(method) }
          end
        end
      end
    end

    def self.decorate(&block)
      new.tap do |reporter|
        reporter.header '下载中'
        reporter.subject = block.call
        reporter.list reporter.subject
      end
    end

  end
end
