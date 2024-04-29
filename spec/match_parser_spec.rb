require 'rspec'
require_relative 'match_parser'

describe MatchParser do
  let(:parser) { MatchParser.new }

  describe '#call' do
    it 'should parse the log file and return matches' do
      matches = parser.call
      expect(matches).to be_a(Hash)
      expect(matches.keys).not_to be_empty
      # Add more expectations based on your knowledge of the log file format
    end
  end

  describe 'parsing correctness' do
    it 'should parse init game lines correctly' do
      line = "1:23 InitGame: started match"
      expect(parser.parse(line)).to have_key(:init_game_line)
    end

    it 'should parse kill lines correctly' do
      line = "2:34 Kill: 1 2 5: player1 killed player2 by MOD_ROCKET"
      expect(parser.parse(line)).to have_key(:kill_line)
    end

    it 'should parse player connect lines correctly' do
      line = "3:45 ClientConnect: 3"
      expect(parser.parse(line)).to have_key(:player_connect_line)
    end

    it 'should parse player changed lines correctly' do
      line = "4:56 ClientUserinfoChanged: 4 n\\player4"
      expect(parser.parse(line)).to have_key(:player_changed_line)
    end
  end

  describe 'match handling' do
    it 'should initialize a new match on InitGame line' do
      parser.parse("1:23 InitGame: started match")
      expect(parser.instance_variable_get(:@current_match)).not_to be_nil
    end

    it 'should conclude a match on match delimiter' do
      parser.instance_variable_set(:@current_match, {}) # Set a match in progress
      parser.parse("------------------------------------------------------------")
      expect(parser.instance_variable_get(:@current_match)).to be_nil
    end
  end

  # Add more tests for player handling and kill handling
end
