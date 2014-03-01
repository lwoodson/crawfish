require 'minitest/spec'
require 'minitest/autorun'
require 'sqlite3'
require 'active_record'
require 'entitree'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'test.db'
)

require_relative 'model.rb'
