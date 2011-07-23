$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'gmusic'

RSpec.configure do |config|
  config.mock_with :rspec
end

def path_of(file)
  File.join(File.dirname(__FILE__), file)
end

