# encoding: UTF-8
require 'gmusic/search/errors'
require 'fileutils'
require 'mechanize'
require 'singleton'

module Gmusic
  module Search
    class Engine < Mechanize
      include Singleton
      include AsyncRequest

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

      def search_album(query)
        url = format_album_url(SEARCH_URL, query)
        page = agent.get(url)
        albums = collect_albums_from page
        urls = albums.map(&:url)

        songs_in_albums = multi_async_get(urls) do |http|
          page = Nokogiri::HTML http.response
          details = collect_details_from page
          details.map {|detail| Song.new detail }
        end

        albums.each { |a| a.songs = songs_in_albums[a.url] }
      end

      #NOTE not finish
      def download(song, dir=nil)
        #TODO
        #`get` should be rescue too
        #maybe pass a song list and then can retry 3 times
        full_address = "#{mkdir dir}/#{song.title}.mp3"
        agent.pluggable_parser.default = Mechanize::Download
        agent.get(song.url) do |page|
          times = 0
          begin
            file = page.links.last.click
          rescue Errno::ETIMEDOUT => e
            return if times > 2
            times += 1
            retry
          end
          file.save full_address
        end

        full_address
      end

      private

      def collect_albums_from(page)
        names = collect_names_from page
        links = page.search('.Title a:first')

        links.map.with_index do |link, i|
          id = extract_album_id link.attributes['href'].value
          Album.new.tap do |a|
            a.artist = names[i]
            a.url = url = ALBUM_URL + id
            a.title = extract_album_title link.text
          end
        end
      end

      def collect_names_from(page)
        page.search('.AlbumInfo .Tracks').map {|node| /(.+)\d{4}年/.match(node.text)[1] }
      end

      def extract_album_title(str)
        /《(.+)》/m.match(str)[1].strip
      end

      def extract_album_id(str)
        /%3D(\p{XDigit}+)&/.match(str)[1]
      end

      def mkdir(dirname)
        return FileUtils.mkdir_p("#{Dir.home}/Downloads/gmusic").first unless dirname
        return dirname if Dir.exists? dirname

        dir = sanitize_dirname dirname
        return FileUtils.mkdir_p(dir).first if /\/.*/.match dir

        FileUtils.mkdir_p(File.join(Dir.pwd, dir)).first
      end

      def sanitize_dirname(dirname)
        dirname.strip.tap do |dir|
          dir.sub!(/^\~/, Dir.home)
          dir.gsub!(/[^\.|^\/|^[:word:]]/, '_')
        end
      end

      def collect_details_from(page)
        page.search('#song_list tbody').map do |tbody|
          id = tbody.attributes['id'].text
          #NOTE change b to a
          title = extract_text_from(tbody, '.Title a')
          artist = extract_text_from(tbody, '.Artist a')

          #TODO
          #make link as an URI object may be better, more OO anyway
          url = DOWNLOAD_URL % id

          { title: title, artist: artist, url: url }
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
      #def agent
      #@agent ||= Mechanize.new
      #end
      def agent
        self.class.instance
      end

      def query_valid?(hash)
        hash.all? { |k, v| SEARCH_OPTSTIONS.include? k.to_sym }
      end

      def not_found?(hash)
        hash.all? { |k, v| v == 0 }
      end

      def format_url(base_url, hash)
        base_url + encode_www_form(hash.values)
      end

      def format_album_url(base_url, hash)
        format_url(base_url, hash) + '&cat=album'
      end

      def encode_www_form(ary)
        str = ary * ' '
        str.downcase.strip.squeeze(' ').gsub(/\s+/, '+')
      end
    end
  end
end
