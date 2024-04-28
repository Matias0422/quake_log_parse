require 'json'
require 'parslet'
require 'parslet/convenience'

require_relative 'death_couse_enum'

class MatchParser < Parslet::Parser
  LOG_FILE_PATH = 'quake_log.txt'
  CHUNK_SIZE = 1000
  MATCH_DELIMITER_REGEX = /-{60}/
  WORLD_NAME = '<world>'

  # Elements
  rule(:number) { match('[0-9]+').repeat(1) }
  rule(:timestamp) { number >> str(':') >> number }
  rule(:name) { match('\w[^\n]+\w').repeat(1) }
  rule(:death_cause) { match('[' + DeathCouseEnum.constants.join('|') + ']').repeat(1) }

  # Lines
  rule(:init_game_line) {
    str('InitGame: ') >>
    match('.+').repeat(1)
  }
  rule(:kill_line) {
    timestamp >>
    str(' Kill: ') >>
    number.as(:killer_id) >>
    str(' ') >>
    number >>
    str(' ') >>
    number >>
    str(': ') >>
    name.as(:killer_name) >>
    str(' killed ') >>
    name.as(:victim_name) >>
    str(' by ') >>_
    death_cause.as(:death_cause)
  }
  rule(:player_connect_line) {
    str('ClientConnect: ') >>
    number.as(:player_id)
  }
  rule(:player_changed_line) {
    str('ClientUserinfoChanged: ') >> 
    number.as(:player_id) >> 
    str('n\\') >>
    name.as(:player_name) >>
    match('.+').repeat(1)
  }

  # Root
  rule(:line) {
    init_game_line.as(:init_game_line) | kill_line.as(:kill_line) | player_connect_line.as(:player_connect_line) | player_changed_line.as(:player_changed_line)
  }
  root :line

  def initialize
    @matches = {}
    @current_match = nil
    @match_counter = 0
  end

  def call
    File.open(LOG_FILE_PATH, "r") do |file|
      while chunk = file.read(CHUNK_SIZE)
        parse_chunk(chunk)
      end
    end

    @matches
  end

  private

  def parse_chunk(chunk)
    chunk.lines do |line|
      if line.match(MATCH_DELIMITER_REGEX) && @current_match
        @match_counter += 1
        @matches["game_#{@match_counter}".to_sym] = @current_match
        @current_match = nil
      else
        parse_line(line)
      end
    end
  end

  def parse_line(line)
    parse_tree = parse_with_debug(line)

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
      kills_by_means: DeathCouseEnum.constants.map do |death_cause|
         [death_cause, 0]
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
    player_name = parse_tree[:player_changed_line][:player_name]

    @current_match[:players][player_id][:name] = player_name
  end

  def handle_kill_line(parse_tree)
    @current_match[:total_kills] += 1

    handle_player_kills(parse_tree)
    handle_kills_by_means(parse_tree)
  end

  def handle_player_kills(parse_tree)
    killer_id = parse_tree[:kill_line][:killer_id].to_i

    if killer_name == WORLD_NAME
      @current_match[:players][killer_id][:kills] += 1
    else
      @current_match[:players][killer_id][:kills] -= 1
    end
  end

  def handle_kills_by_means(parse_tree)
    death_cause = parse_tree[:kill_line][:death_cause].to_sym

    @current_match[:kills_by_means][death_cause] += 1
  end
end
