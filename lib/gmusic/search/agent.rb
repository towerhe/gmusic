# encoding: UTF-8
require 'gmusic/search/result'
require 'gmusic/search/errors'
require 'mechanize'

module Gmusic
  module Search
    class Agent

      class << self
        #TODO not finish
        def search(query)
          raise InvalidParameter unless query_valid?(query)

          query_url = format_url(SEARCH_URL, query)
          page = agent.get(query_url)
          info = extract_info_from page
          links = collect_links_from page

          Result.new(info, links)
        end

        private
        def collect_links_from(page)
          page.search('#song_list tbody').map do |tbody|
            id = tbody.attributes['id'].text
            title = extract_text_from(tbody, '.Title b')
            link = DOWNLOAD_URL % id

            { title: title, link: link }
          end
        end

        def extract_info_from(page)
          text = extract_text_from(page, '.topheadline')
          pattern = /\((\d+)\)/
          figures = text.scan(pattern).flatten.map { |item| item.to_i }
          mappings = %w{歌曲 专辑 歌手}.zip(figures)
          info = Hash[mappings]
          raise NotFound if not_found?(info)

          info
        end

        def extract_text_from(scope, element)
          scope.search(element).text
        end

        def agent
          Mechanize.new
        end

        def query_valid?(hash)
          return false if hash.empty?
          hash.each_key { |key| return false unless SEARCH_OPTSTIONS.include?(key.to_sym) }

          true
        end

        def not_found?(hash)
          hash.each_value { |v| return false if v != 0 }
          true
        end

        def format_url(base_url, hash)
          base_url + encode_www_form(hash.values)
        end

        def encode_www_form(ary)
          str = ary * ' '
          str.downcase.strip.squeeze(' ').gsub(/\s+/, '+')
        end
      end
    end
  end
end
