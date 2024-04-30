require_relative '../line_handling_strategy.rb'

class PlayerChangedLineStrategy < LineHandlingStrategy

  def handle(current_match)
    player_id = @parse_tree[:player_id].to_i
    player_name = @parse_tree[:player_name].to_s

    player = current_match.find_player_by_id(player_id)
    player.name = player_name

    current_match
  end
end
