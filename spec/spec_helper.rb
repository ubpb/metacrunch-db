require "pry" if !ENV["CI"]

require "simplecov"
SimpleCov.start

require "metacrunch/db"

RSpec.configure do |config|
end

def asset_dir
  File.expand_path(File.join(File.dirname(__FILE__), "assets"))
end

