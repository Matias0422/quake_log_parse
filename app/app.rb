
if ENV['APP_ENV'] != 'production'
  require 'dotenv'

  Dotenv.load(".env.#{(ENV['APP_ENV'] || 'development')}")
end

require_relative './parsers/quake_log_parser.rb'

QuakeLogParser.new.call
