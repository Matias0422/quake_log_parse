require 'json'
require 'byebug'
require 'parslet'
require 'parslet/convenience'

require_relative 'death_couse_enum'

class MatchParser < Parslet::Parser
  LOG_FILE_PATH = 'quake_log.txt'
  LINES_CHUNK = 100
  MATCH_DELIMITER_REGEX = /-{60}/
  WORLD_PLAYER_ID = 1022

  # Elements
  rule(:space)  { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:number) { match('[0-9]+').repeat(1) }
  rule(:timestamp) { number >> str(':') >> number }
  rule(:name) { match('\w[^\n]+\w').repeat(1) }
  rule(:death_couse) { match('[' + DeathCouseEnum.constants.join('|') + ']').repeat(1) }

  # Lines
  rule(:init_game_line) {
    str('InitGame: ')
  }
  rule(:kill_line) {
    str('Kill: ') >>
    number.as(:killer_id) >>
    space >>
    number.as(:victim_id) >>
    space >>
    number >>
    str(': ') >>
    name.as(:killer_name) >>
    str(' killed ') >>
    name.as(:victim_name) >>
    str(' by ') >>
    death_couse.as(:death_couse)
  }
  rule(:player_connect_line) {
    str('ClientConnect:') >>
    space >>
    number.as(:player_id)
  }
  rule(:player_changed_line) {
    str('ClientUserinfoChanged: ') >>
    number.as(:player_id) >>
    str(' n\\') >>
    name.as(:player_name)
  }

  # Root
  rule(:default_beginning) { space? >> timestamp >> space }
  rule(:default_end) { match('.+').repeat(1).maybe }
  rule(:line) {
    default_beginning >>
    (
      init_game_line.as(:init_game_line) |
      kill_line.as(:kill_line) |
      player_connect_line.as(:player_connect_line) |
      player_changed_line.as(:player_changed_line)
    ) >>
    default_end
  }
  root :line

  def initialize
    @matches = {}
    @current_match = nil
    @match_counter = 0
  end

  def call
    File.open(LOG_FILE_PATH, "r") do |file|
      file.each_slice(LINES_CHUNK) do |lines|
        parse_lines(lines)
      end
    end

    @matches
  end

  private

  def parse_lines(lines)
    lines.each do |line|
      next if line.match(MATCH_DELIMITER_REGEX) && @current_match.nil?
      conclude_match && next if line.match(MATCH_DELIMITER_REGEX) && @current_match

      parse_line(line)
    end
  end

  def conclude_match
    @match_counter += 1
    @matches["game_#{@match_counter}".to_sym] = @current_match
    @current_match = nil
  end

  def parse_line(line)
    parse_tree = parse_with_debug(line)

    return if parse_tree.nil?

    case(parse_tree.keys.last)
    when :init_game_line
      handle_init_game_line(parse_tree)
    when :kill_line
      handle_kill_line(parse_tree)
    when :player_connect_line
      handle_player_connect_line(parse_tree)
    when :player_changed_line
      handle_player_changed_line(parse_tree)
    else
      # do nothing
    end
  end

  def handle_init_game_line(parse_tree)
    @current_match = {
      total_kills: 0,
      players: {},
      kills_by_means: DeathCouseEnum.constants.map do |death_couse|
         [death_couse, 0]
      end.to_h
    }
  end

  def handle_player_connect_line(parse_tree)
    player_id = parse_tree[:player_connect_line][:player_id].to_i

    @current_match[:players][player_id] = {
      name: nil,
      kills: 0
    }
  end

  def handle_player_changed_line(parse_tree)
    player_id = parse_tree[:player_changed_line][:player_id].to_i
    player_name = parse_tree[:player_changed_line][:player_name].to_s

    @current_match[:players][player_id][:name] = player_name
  end

  def handle_kill_line(parse_tree)
    @current_match[:total_kills] += 1

    handle_player_kills(parse_tree)
    handle_kills_by_means(parse_tree)
  end

  def handle_player_kills(parse_tree)
    killer_id = parse_tree[:kill_line][:killer_id].to_i
    victim_id = parse_tree[:kill_line][:victim_id].to_i

    if killer_id == WORLD_PLAYER_ID
      @current_match[:players][victim_id][:kills] -= 1
    else
      @current_match[:players][killer_id][:kills] += 1
    end
  end

  def handle_kills_by_means(parse_tree)
    death_couse = parse_tree[:kill_line][:death_couse].to_sym

    @current_match[:kills_by_means][death_couse] += 1
  end
end

MatchParser.new.call
