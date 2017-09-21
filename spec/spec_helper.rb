require "pry"
require "simplecov"

require "metacrunch/db"

SimpleCov.start

RSpec.configure do |config|
end

def asset_dir
  File.expand_path(File.join(File.dirname(__FILE__), "assets"))
end

