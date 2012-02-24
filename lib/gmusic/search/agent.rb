# encoding: UTF-8
require 'gmusic/search/result'
require 'gmusic/search/errors'
require 'mechanize'

module Gmusic
  module Search
    class Agent

      class << self
        #NOTE not finish
        def search(query)
          raise InvalidParameter unless query_valid?(query)

          query_url = format_url(SEARCH_URL, query)

          #TODO should wrapped in begin rescue pair
          # retry or raise, make it more robust
          page = agent.get(query_url)

          info = extract_info_from page
          details = collect_details_from page

          Result.new(info, details)
        end

        #NOTE not finish
        def download(song, dir=nil)
          #TODO
          #`get` should be rescue too
          #maybe pass a song list and then can retry 3 times
          agent.get(song.link) do |page|
            begin
              file = page.links.last.click
            rescue Errno::ETIMEDOUT => e
              #do_something
            end
            file.save(dir || "#{Dir.home}/Downloads/gmusic/")
          end
        end

        private
        def collect_details_from(page)
          page.search('#song_list tbody').map do |tbody|
            id = tbody.attributes['id'].text
            title = extract_text_from(tbody, '.Title b')
            artist = extract_text_from(tbody, '.Artist a')

            #TODO
            #make link as an URI object may be better, more OO anyway
            link = DOWNLOAD_URL % id

            { title: title, artist: artist, link: link }
          end
        end

        #def collect_links_from(page)
          #page.search('#song_list tbody').map do |tbody|
            #id = tbody.attributes['id'].text
            #title = extract_text_from(tbody, '.Title b')
            #url = DOWNLOAD_URL % id

            ##{ title: title, link: link }
            #Link.new(title, url)
          #end
        #end

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

        #TODO
        #set a logger for the agent
        #http://mechanize.rubyforge.org/Mechanize.html
        def agent
          @agent ||= Mechanize.new
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
