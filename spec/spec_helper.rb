require 'rspec'

ENV['APP_ENV'] = 'test'

Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
end
