require 'parslet'
require 'parslet/convenience'
require 'byebug'

require './app/entities/match.rb'
require './app/enumarators/death_cause_enum.rb'
require './app/factories/line_handling_strategy_factory.rb'
require './app/reports/match_report.rb'

class QuakeLogParser < Parslet::Parser
  MATCH_DELIMITER_REGEX = /-{60}/

  # Elements
  rule(:space)  { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:number) { match('[0-9]+').repeat(1) }
  rule(:timestamp) { number >> str(':') >> number }
  rule(:death_cause) { match('[' + DeathCauseEnum.constants.join('|') + ']').repeat(1) }

  # Lines
  rule(:init_game_line) {
    str('InitGame:')
  }
  rule(:shut_down_game_line) {
    str('ShutdownGame:')
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
    (str('\t').absent? >> any ).repeat.as(:player_name)
  }
  rule(:kill_line) {
    str('Kill: ') >>
    number.as(:killer_id) >>
    space >>
    number.as(:victim_id) >>
    space >>
    number >>
    str(': ') >>
    (str(' killed ').absent? >> any).repeat.as(:killer_name) >>
    str(' killed ') >>
    (str(' by ').absent? >> any).repeat.as(:victim_name) >>
    str(' by ') >>
    death_cause.as(:death_cause)
  }

  # Root
  rule(:default_beginning) { space? >> timestamp >> space }
  rule(:default_ending) { match('.+').repeat(1).maybe }
  rule(:line) {
    default_beginning >>
    (
      init_game_line.as(:init_game_line) |
      shut_down_game_line.as(:shut_down_game_line) |
      player_connect_line.as(:player_connect_line) |
      player_changed_line.as(:player_changed_line) |
      kill_line.as(:kill_line)
    ) >>
    default_ending
  }
  root :line

  def initialize
    @current_match = nil
  end

  def call
    File.open(ENV['LOG_FILE_PATH'], "r") do |file|
      file.each_slice(ENV['LINES_BATCH_NUMBER'].to_i) do |lines|
        lines.each { |line| parse_line(line) }
      end
    end
  end

  private

  def parse_line(line)
    if can_initialize_match?(line)
      initialize_match!
    elsif can_finalize_match?(line)
      finalize_match!
    elsif is_match_incomplete?(line)
      make_match_incomplete!
    else
      line_handling!(line)
    end
  end

  def line_handling!(line)
    parse_tree = create_parse_tree(line)

    if parse_tree
      line_handling_strategy(parse_tree).handle(@current_match)
    end
  end

  def create_parse_tree(line)
    parse_with_debug(line)
  rescue Parslet::ParseFailed
    nil
  end

  def line_handling_strategy(parse_tree)
    LineHandlingStrategyFactory.create_strategy(parse_tree)
  end

  def can_initialize_match?(line)
    line.match(MATCH_DELIMITER_REGEX) && @current_match.nil?
  end

  def can_finalize_match?(line)
    line.match(MATCH_DELIMITER_REGEX) && @current_match&.parse_finished?
  end

  def is_match_incomplete?(line)
    line.match(MATCH_DELIMITER_REGEX) && @current_match&.parse_initialized?
  end

  def initialize_match!
    @current_match = Match.new
  end

  def finalize_match!
    print_report!
    reset_match!
  end

  def make_match_incomplete!
    @current_match.parse_incomplete!
    finalize_match!
    initialize_match!
  end

  def reset_match!
    @current_match = nil
  end

  def print_report!
    MatchReport.new.print!(@current_match)
  end
end
