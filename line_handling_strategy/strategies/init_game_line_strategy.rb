require './entities/match.rb'

require_relative '../line_handling_strategy.rb'

class InitGameLineStrategy < LineHandlingStrategy
  def handle(_parse_tree, _current_match)
    Match.new
  end
end
