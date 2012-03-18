require 'fakeweb'

def path_to(filename)
  File.join(File.dirname(__FILE__), '..', 'web_pages', filename)
end

def prepare_fake_web(filename, url)
  stream = File.read(path_to(filename))
  FakeWeb.register_uri(:get, url, :body => stream, :content_type => "text/html")
end

def dir_exist?(path)
  begin
    Dir.delete path
  rescue Errno::ENOENT
    return false
  end

  true
end

def clean_up_files_generated_by_fakeweb
  Dir.glob('for_test.mp3.[0-9]').each { |f| File.delete f }
end
