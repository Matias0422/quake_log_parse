require_relative '../match_line_handling_strategy.rb'

class InitGameLineStrategy
  include MatchLineHandlingStrategy

  def handle(current_match)
    current_match.parse_initialize!
  end
end
