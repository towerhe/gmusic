require 'thor'
require 'gmusic/cli/reporter'
require 'gmusic'

module Gmusic
  class CLI < Thor
    map 's' => :search, 'd' => :download

    desc 'search', 'Search songs or albums'
    method_options %w(title -t) => :string, %w(album -a) => :boolean
    def search
      title = formatted_title options[:title]

      return search_album(title) if options[:album]

      search_song title
    end

    desc 'download', 'Download songs or albums'
    method_options %w(title -t) => :string,
                   %w(album -a) => :string,
                   %w(directory -d) => :string
    def download
      Song.download(formatted_title, options[:directory])
    end

    private

    def ask_for_a_number(limit)
      answer = ask "Please type a number in #{(1..limit)}"
      number = /^\d+$/.match(answer)

      send(__callee__, limit) unless number

      number = number[0].to_i
      return number if number <= limit

      send(__callee__, limit)
    end

    def ask_for_numbers(limit)
      answer = ask <<-EOF
        Please type one or more numbers in #{(1..limit)}, sperated by comma!
        Type 0 or any non-digit to to download the whole album.
      EOF
      numbers = answer.strip.split(/\s*,\s*/).map(&:to_i)

      numbers.uniq # non-digit char will be 0 when received :to_i
                   # also restrict duplications
    end

    def formatted_title(str)
      str.gsub(/-/, ' ')
    end

    def search_album(title)
      reporter = Reporter.decorate do
        Album.search(title: title)
      end

      albums = reporter.subject
      id = ask_for_a_number(albums.size)
      songs = albums[id].songs
      reporter.list songs

      ids = ask_for_numbers songs.size
      songs = ids.map {|i| songs[i-1] }

      Download::SyncAgent.download(songs)
    end

    def search_song(title)
      reporter = Reporter.decorate do
        Song.search_by_title(title)
      end

      songs = reporter.subject
      id = ask_for_a_number(songs.size) - 1

      songs[id].save
    end

  end
end
