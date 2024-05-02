require 'rspec'
require_relative 'quake_log_parser'

RSpec.describe QuakeLogParser do
  let(:parser) { QuakeLogParser.new }

  describe '#call' do
    it 'parses the log file' do
      allow(ENV).to receive(:[]).with('LOG_FILE_PATH').and_return('path/to/log.txt')
      allow(ENV).to receive(:[]).with('LINES_BATCH_NUMBER').and_return('100')

      file_double = double('file')
      allow(File).to receive(:open).with('path/to/log.txt', 'r').and_yield(file_double)
      allow(file_double).to receive(:each_slice).with(100).and_yield(["line1\n", "line2\n"])

      expect(parser).to receive(:parse_line).with("line1\n").once
      expect(parser).to receive(:parse_line).with("line2\n").once

      parser.call
    end
  end

  # You can write similar tests for other methods in the class
end