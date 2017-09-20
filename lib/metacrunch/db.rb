require "active_support"
require "active_support/core_ext"
require "sequel"

module Metacrunch
  module DB
    require_relative "db/source"
    require_relative "db/destination"
  end
end
