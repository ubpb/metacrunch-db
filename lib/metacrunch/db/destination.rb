require "metacrunch/db"

module Metacrunch
  class DB::Destination

    DEFAULT_OPTIONS = {
      use_upsert: false,
      primary_key: :id,
      transaction_options: {}
    }

    def initialize(sequel_dataset, options = {})
      @dataset = sequel_dataset
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def write(data)
      @dataset.db.transaction(@options[:transaction_options]) do
        if data.is_a?(Array)
          data.each{|d| insert_or_upsert(d) }
        else
          insert_or_upsert(data)
        end
      end
    end

    def close
      @dataset.db.disconnect
    end

  private

    def insert_or_upsert(data)
      @use_upsert ? upsert(data) : insert(data)
    end

    def insert(data)
      @dataset.insert(data) if data
    end

    def upsert(data)
      if data
        primary_key = @options[:primary_key]

        rec = @dataset.where(primary_key => data[primary_key])
        if 1 != rec.update(data)
          insert(data)
        end
      end
    end

  end
end
