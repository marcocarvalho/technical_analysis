require 'bundler'
Bundler.setup
# require "bundler/gem_tasks"
require 'active_record'
require 'sqlite3'
require 'mysql2'
require 'yaml'
require 'logger'

# desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yaml'))[ ENV['RACK_ENV'] || 'development'])
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
