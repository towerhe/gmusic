require 'gmusic'
require 'pry'
require 'plymouth'
require 'fakeweb'

def path_to(filename)
  File.join(File.dirname(__FILE__), 'web_pages', filename)
end

def prepare_fake_web(filename, url)
  stream = File.read(path_to(filename))
  FakeWeb.register_uri(:get, url, :body => stream, :content_type => "text/html")
end
