require 'open-uri'
require 'nokogiri'

module Gmusic
  module Download

    class SyncAgent
      extend AsyncRequest
      DEFAULT_DIRECTORY = File.expand_path '~/Downloads'
      HOST = 'http://www.google.cn'

      class << self
        def download(*songs)
          songs.flatten!
          raise InvalidArgument, 'must be a song or an array of songs' if songs.empty?

          urls = songs.map(&:url)
          tempfiles = get_files(urls, Download.config.concurrency)
          results = songs.map { |s| save(s.title, tempfiles[s.url]) }
          failures = results.select {|r| r.is_a? String }

          failures.empty? ? DEFAULT_DIRECTORY : failures
        end

        private

        def get_files(urls, concurrency)
          multi_async_get(urls, concurrency) do |http|
            page = Nokogiri::HTML http.response
            node = page.search('.download a:first')
            url = HOST + node[1].attributes['href'].value
            open url
          end
        end

        def save(filename, tempfile)
          fname = File.join(DEFAULT_DIRECTORY, filename + '.mp3')
          File.open(fname, 'w+') do |f|
            begin
              f.write tempfile.read
            rescue
              return filename
            ensure
              f.close
              tempfile.unlink
            end
          end

          true
        end
      end
    end

  end
end
