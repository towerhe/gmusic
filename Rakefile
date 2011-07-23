require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gmusic"
    gem.summary = %Q{Search songs from http://music.g.cn}
    gem.description = %Q{gmusic provides APIs to search songs from http://music.g.cn. There are three query conditions supported by gmusic, which are title, artist and album of a song. gmusic delivers query requests to Google and collects the search result returned from Google. }
    gem.email = "towerhe@gmail.com"
    gem.homepage = "http://github.com/towerhe/gmusic"
    gem.authors = ["Tower He"]
    gem.add_dependency "hpricot", ">=0.8.2"
    gem.add_development_dependency "rspec", ">= 1.2.9"

    gem.files = FileList['lib/**/*.rb', 'spec/**/*.rb', '[A-Z]*'].to_a
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gmusic #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
