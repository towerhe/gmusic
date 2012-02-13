# encoding: UTF-8
require 'gmusic/search/result'
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
          not hash.empty?
        end

        def not_found?(hash)
          hash.each_value do |v|
            return false if v != 0
          end

          true
        end

        def format_url(base_url, hash)
          url = ''
          SEARCH_OPTSTIONS.each do |opt|
            url += "#{hash[opt]} "
          end

          format(base_url + url)
        end

        def format(str)
          str.downcase.gsub(/^\s+|\s+$/, '').gsub(/\s+/, '%20')
        end
      end
    end
  end
end
