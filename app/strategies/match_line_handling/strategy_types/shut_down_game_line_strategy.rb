require_relative '../match_line_handling_strategy.rb'

class ShutDownGameLineStrategy
  include MatchLineHandlingStrategy

  def handle(current_match)
    current_match.parse_finalize!
  end
end
