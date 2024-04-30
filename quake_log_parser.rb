require 'json'
require 'parslet'

require './enumarators/death_cause_enum.rb'

class QuakeLogParser < Parslet::Parser
  MATCH_DELIMITER_REGEX = /-{60}/

  # Elements
  rule(:space)  { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:number) { match('[0-9]+').repeat(1) }
  rule(:timestamp) { number >> str(':') >> number }
  rule(:name) { match('\w[^\n]+\w').repeat(1) }
  rule(:death_cause) { match('[' + DeathCauseEnum.constants.join('|') + ']').repeat(1) }

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
    death_cause.as(:death_cause)
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
  rule(:default_ending) { match('.+').repeat(1).maybe }
  rule(:line) {
    default_beginning >>
    (
      init_game_line.as(:init_game_line) |
      kill_line.as(:kill_line) |
      player_connect_line.as(:player_connect_line) |
      player_changed_line.as(:player_changed_line)
    ) >>
    default_ending
  }
  root :line

  def initialize
    @current_match = nil
    @match_report = MatchReport.new
  end

  def call
    File.open(ENV['LOG_FILE_PATH'], "r") do |file|
      file.each_slice(ENV['LINES_BATCH_NUMBER']) do |lines|
        parse_lines(lines)
      end
    end

    @match_report.print!
  end

  private

  def parse_lines(lines)
    lines.each do |line|
      if line.match(MATCH_DELIMITER_REGEX) && @current_match.nil?
        next
      elsif line.match(MATCH_DELIMITER_REGEX) && @current_match
        conclude_match
      else
        parse_line(line)
      end
    end
  end

  def parse_line(line)
    parse_tree = parse(line)
    line_handling_strategy = LineHandlingStrategyFactory.create_strategy(parse_tree)

    @current_match = line_handling_strategy.handle(@current_match)
  rescue Parslet::ParseFailed
    return
  end

  def conclude_match
    @match_report.increment_line(@current_match)
    @current_match = nil
  end
end

QuakeLogParser.new.call
