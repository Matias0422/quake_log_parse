require_relative '../line_handling_strategy.rb'

class ShutDownGameLineStrategy
  include LineHandlingStrategy

  def handle(current_match)
    current_match.parse_finalize!
  end
end
