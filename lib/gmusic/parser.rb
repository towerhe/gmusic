module GMusic
  module SongListParser
    class << self
      def parse url
        songs = []
        doc = Hpricot(open(url))
        (doc/'#song_list > tr').each do |tr|
          begin
            song = {}
            id = tr.attributes["id"].gsub(/row/, '')
            next if id.include?('snippetRow')
            song.merge!({ :id => id })
            song.merge!({ :title => (tr/'td.Title > a > b').first.inner_html })
            song.merge!({ :artist => (tr/'td.Artist > a').first.inner_html })
            song.merge!({ :album => (tr/'td.Album > a').first.inner_html })
            songs << song
          rescue
          end
        end
        songs
      end
    end
  end

  module LyricsParser
    class << self
      def parse url
        doc = Hpricot(open(url))
        begin
          { :lyrics => (doc/'#lyrics').first.inner_html }
        rescue
          nil
        end
      end
    end
  end

  module DownloadInfoParser
    class << self
      def parse url
        result = {}
        doc = Hpricot(open(url))
        begin
          result.merge!({ :size => (doc/'tr.meta-data-tr > td.td-size').first.inner_html })
          result.merge!({ :format => (doc/'tr.meta-data-tr > td.td-format').first.inner_html })
          result.merge!({ :url => (doc/'div.download > a').first.attributes['href'] })
        rescue
          nil
        end
      end
    end
  end
end
