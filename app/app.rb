require 'dotenv'

environment = ENV['APP_ENV'] || 'development'
Dotenv.load(".env.#{environment}")

require_relative 'quake_log_parser'

QuakeLogParser.new.call
