require 'rspec'
require 'dotenv'

ENV['APP_ENV'] = 'test'
Dotenv.load(".env.test")

Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
end
