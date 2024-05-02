require './app/entities/match.rb'
require './app/factories/match_line_handling_strategy_factory.rb'
require './app/reports/match_report.rb'

require_relative 'match_line_parser'

class QuakeLogParser
  MATCH_DELIMITER_REGEX = /-{60}/

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
    elsif can_make_match_incomplete?(line)
      make_match_incomplete!
    else
      match_line_handling!(line)
    end
  end

  def match_line_handling!(line)
    parse_tree = create_match_line_parse_tree(line)

    if parse_tree
      match_line_handling_strategy(parse_tree).handle(@current_match)
    end
  end

  def create_match_line_parse_tree(line)
    MatchLineParser.new.parse(line)
  rescue Parslet::ParseFailed
    nil
  end

  def match_line_handling_strategy(parse_tree)
    MatchLineHandlingStrategyFactory.create_strategy(parse_tree)
  end

  def can_initialize_match?(line)
    line.match(MATCH_DELIMITER_REGEX) && @current_match.nil?
  end

  def can_finalize_match?(line)
    line.match(MATCH_DELIMITER_REGEX) && @current_match&.parse_finished?
  end

  def can_make_match_incomplete?(line)
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
