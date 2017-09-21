require "metacrunch/db"

module Metacrunch
  class DB::Source

    DEFAULT_OPTIONS = {
      rows_per_fetch: 1000,
      strategy: :filter,
      filter_values: nil
    }

    def initialize(sequel_dataset, options = {})
      @dataset = sequel_dataset
      @options = DEFAULT_OPTIONS.merge(options)

      unless @dataset.opts[:order]
        raise ArgumentError, "The dataset must be ordered."
      end
    end

    def each(&block)
      return enum_for(__method__) unless block_given?

      @dataset.paged_each(
        rows_per_fetch: @options[:rows_per_fetch],
        strategy: @options[:strategy],
        filter_values: @options[:filter_values]
      ) do |row|
        yield(row)
      end

      self
    end

  end
end
