require_relative '../match_line_handling_strategy.rb'

class PlayerConnectLineStrategy
  include MatchLineHandlingStrategy

  def handle(current_match)
    player_id = @parse_tree[:player_id].to_i

    current_match.add_player(player_id)

    current_match
  end
end
