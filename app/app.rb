require 'dotenv'

environment = ENV['APP_ENV'] || 'development'
Dotenv.load(".env.#{environment}")

require_relative './parsers/quake_log_parser.rb'

QuakeLogParser.new.call
