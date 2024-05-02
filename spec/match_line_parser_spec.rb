require 'rspec'
require 'parslet'
require 'parslet/rig/rspec'
require './app/enumarators/death_cause_enum.rb'
require './app/match_line_parser.rb'

RSpec.describe MatchLineParser do
  let(:parser) { MatchLineParser.new }

  describe '#space' do
    it 'parses one or more whitespace characters' do
      expect(parser.space).to parse(" ")
      expect(parser.space).to parse("\t")
      expect(parser.space).to parse("\n")
    end
  end

  describe '#space?' do
    it 'parses zero or more whitespace characters' do
      expect(parser.space?).to parse("")
      expect(parser.space?).to parse(" ")
      expect(parser.space?).to parse("\t")
    end
  end

  describe '#number' do
    it 'parses one or more digits' do
      expect(parser.number).to parse("123")
      expect(parser.number).to parse("0")
    end
  end

  describe '#timestamp' do
    it 'parses a timestamp in the format "number:number"' do
      expect(parser.timestamp).to parse("12:34")
      expect(parser.timestamp).to parse("0:0")
    end
  end

  describe '#death_cause' do
    it 'parses a death cause from the DeathCauseEnum' do
      DeathCauseEnum.constants.each do |cause|
        expect(parser.death_cause).to parse(cause.to_s)
      end
    end
  end

  describe '#init_game_line' do
    it 'parses the "InitGame:" line' do
      expect(parser.init_game_line).to parse("InitGame:")
    end
  end

  describe '#shut_down_game_line' do
    it 'parses the "ShutdownGame:" line' do
      expect(parser.shut_down_game_line).to parse("ShutdownGame:")
    end
  end

  describe '#player_connect_line' do
    it 'parses the "ClientConnect:" line with player_id' do
      parse_tree = parser.player_connect_line.parse("ClientConnect: 123")

      expect(parse_tree[:player_id].to_i).to eq(123)
    end
  end

  describe '#player_changed_line' do
    it 'parses the "ClientUserinfoChanged:" line with player_id and player_name' do
      parse_tree = parser.player_changed_line.parse("ClientUserinfoChanged: 123 n\\PlayerName")

      expect(parse_tree[:player_id].to_i).to eq(123)
      expect(parse_tree[:player_name].to_s).to eq('PlayerName')
    end
  end

  describe '#kill_line' do
    it 'parses the "Kill:" line with killer_id, victim_id, killer_name, victim_name, and death_cause' do
      parse_tree = parser.kill_line.parse("Kill: 1 2 100: Killer killed Victim by MOD_RAILGUN")

      expect(parse_tree[:killer_id].to_i).to eq(1)
      expect(parse_tree[:victim_id].to_i).to eq(2)
      expect(parse_tree[:killer_name].to_s).to eq('Killer')
      expect(parse_tree[:victim_name].to_s).to eq('Victim')
      expect(parse_tree[:death_cause].to_s).to eq('MOD_RAILGUN')
    end

    it 'parses the "Kill:" line with multi-word killer_name and victim_name' do
      parse_tree = parser.kill_line.parse("Kill: 1 2 100: The Great Killer killed The Poor Victim by MOD_RAILGUN")

      expect(parse_tree[:killer_id].to_i).to eq(1)
      expect(parse_tree[:victim_id].to_i).to eq(2)
      expect(parse_tree[:killer_name].to_s).to eq('The Great Killer')
      expect(parse_tree[:victim_name].to_s).to eq('The Poor Victim')
      expect(parse_tree[:death_cause].to_s).to eq('MOD_RAILGUN')
    end
  end

  describe '#line' do
    let(:default_beginning) { " 20:20 " }

    it 'parses the kill_line with the expected key in the parse tree' do
      parse_tree = parser.line.parse(default_beginning + "Kill: 1 2 100: Killer killed Victim by MOD_RAILGUN")

      expect(parse_tree).to have_key(:kill_line)
    end

    it 'parses the player_changed_line with the expected key in the parse tree' do
      parse_tree = parser.line.parse(default_beginning + "ClientUserinfoChanged: 123 n\\PlayerName")

      expect(parse_tree).to have_key(:player_changed_line)
    end

    it 'parses the init_game_line with the expected key in the parse tree' do
      parse_tree = parser.line.parse(default_beginning + "InitGame:")

      expect(parse_tree).to have_key(:init_game_line)
    end

    it 'parses the shut_down_game_line with the expected key in the parse tree' do
      parse_tree = parser.line.parse(default_beginning + "ShutdownGame:")

      expect(parse_tree).to have_key(:shut_down_game_line)
    end

    it 'parses the player_connect_line with the expected key in the parse tree' do
      parse_tree = parser.line.parse(default_beginning + "ClientConnect: 123")

      expect(parse_tree).to have_key(:player_connect_line)
    end
  end
end
