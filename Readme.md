metacrunch-db
=============

[![Gem Version](https://badge.fury.io/rb/metacrunch-db.svg)](http://badge.fury.io/rb/metacrunch-db)
[![Code Climate](https://codeclimate.com/github/ubpb/metacrunch-db/badges/gpa.svg)](https://codeclimate.com/github/ubpb/metacrunch-db)
[![Build Status](https://travis-ci.org/ubpb/metacrunch-db.svg)](https://travis-ci.org/ubpb/metacrunch-db)

This is the official SQL database package for the [metacrunch ETL toolkit](https://github.com/ubpb/metacrunch). The implementation uses the [Sequel](https://github.com/jeremyevans/sequel) Gem as a dependency. Every database that is supported by Sequel can be used with this package.

Installation
------------

Include the gem in your `Gemfile`

```ruby
gem "metacrunch-db", "~> 1.0.0"
```

and run `$ bundle install` to install it.

Or install it manually

```
$ gem install metacrunch-db
```


Usage
-----

*Note: For working examples on how to use this package check out our [demo repository](https://github.com/ubpb/metacrunch-demo).*

### `Metacrunch::DB::Source`

This class provides a metacrunch `source` implementation that can be used to read data from SQL databases into a metacrunch job.

```ruby
# my_job.metacrunch

# Create a Sequel database connection 
SOURCE_DB = Sequel.connect(...)

# Create a Sequel dataset with an unambiguous order.
my_source_dataset = SOURCE_DB[:my_table].order(:id)

# Set the source
source Metacrunch::DB::Source.new(my_source_dataset [, OPTIONS])
```

The implementation uses Sequel's [`paged_each`](http://www.rubydoc.info/github/jeremyevans/sequel/Sequel%2FDataset%3Apaged_each) to efficiently iterate even over large result sets. You can provide the following options, to control how `paged_each` works.

**Options**

For a detailed descriptions consult the Sequel documentation of [`paged_each`](http://www.rubydoc.info/github/jeremyevans/sequel/Sequel%2FDataset%3Apaged_each). Please note that the default for `strategy` has been changed to `:filter`.

* `:rows_per_fetch`: Defaults to 1000.
* `:strategy`: `:offset` or `:filter`, Defaults to `:filter`.
* `:filter_values`: Defaults to `nil`


### `Metacrunch::DB::Destination`

This class provides a metacrunch `destination` implementation that can be used to write data from a metacrunch job to SQL databases.

```ruby
# my_job.metacrunch

# Create a Sequel database connection 
DEST_DB = Sequel.connect(...)

# Create a Sequel dataset where data should be written
my_target_dataset = DEST_DB[:my_table]

# For performance reasons it may be useful to create a batch
# of records that gets written to the database
transformation ->(row) { row }, batch_size: 1000

# Set the destination
destination Metacrunch::DB::Destination.new(my_target_dataset [, OPTIONS])
```

**Options**

* `:use_upsert`: When set to `true` it will perform an upsert (Update an existing record) and not an insert. Defaults to `false`.
* `:primary_key`: The primary key to use to identify an existing record in case of an upsert. It defaults to `:id`.
* `:transaction_options`: A hash of options to control how the database should handle the transaction. For a complete list of available options checkout out the Sequel documentation [here](http://www.rubydoc.info/github/jeremyevans/sequel/Sequel/Database#transaction-instance_method).
