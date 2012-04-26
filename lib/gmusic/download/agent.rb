require 'confstruct'
require 'nokogiri'

module Gmusic
  module Download

    class InvalidArgument < ArgumentError; end

    def self.config
      @@config ||= ::Confstruct::Configuration.new do
        concurrency 3
      end
    end

    class Agent
      extend AsyncRequest
      DEFAULT_DIRECTORY = File.expand_path '~/Downloads'
      HOST = 'http://www.google.cn'

      class << self
        def download(*songs)
          songs.flatten!
          raise InvalidArgument, 'must be a song or an array of songs' if songs.empty?

          download_files(songs, Download.config.concurrency)
        end

        private

        def download_files(songs, concurrency)
          urls = songs.map(&:url)
          mapping = get_download_url_mapping(urls, concurrency)
          responses = multi_async_get(mapping.values, concurrency)

          songs.map do |s|
            key = mapping[s.url].hash
            save s.title, responses[key]
          end
        end

        def get_download_url_mapping(urls, concurrency)
          tmp_urls = get_tmp_url_mapping(urls, concurrency)
          interim_mapping = map_urls(urls, tmp_urls)
          download_urls = multi_async_get(tmp_urls.values, concurrency) do |http|
            http.response_header['LOCATION']
          end

          map_urls(interim_mapping, download_urls)
        end

        def map_urls(keys, values)
          mapping = keys.map { |i| [i, values[i.hash]] }
          Hash[mapping]
        end

        def get_tmp_url_mapping(urls, concurrency)
          multi_async_get(urls, concurrency) do |http|
            page = Nokogiri::HTML http.response
            node = page.search('.download a:first')

            HOST + node[1].attributes['href'].value
          end
        end

        def save(filename, content)
          fname = File.join(DEFAULT_DIRECTORY, filename + '.mp3')
          File.open(fname, 'w+') do |f|
            begin
              f.write content
            ensure
              f.close
            end
          end

          fname
        end
      end

    end
  end
end
