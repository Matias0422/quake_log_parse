require_relative '../line_handling_strategy.rb'

class InitGameLineStrategy
  include LineHandlingStrategy

  def handle(current_match)
    current_match.parse_initialize!
  end
end
