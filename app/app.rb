require 'dotenv'

Dotenv.load(".env.#{(ENV['APP_ENV'] || 'local')}")

require_relative './parsers/quake_log_parser.rb'

QuakeLogParser.new.call
