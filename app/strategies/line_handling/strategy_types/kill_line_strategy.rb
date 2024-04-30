require_relative '../line_handling_strategy.rb'

class KillLineStrategy < LineHandlingStrategy

  def handle(current_match)
    killer_id = @parse_tree[:killer_id].to_i
    victim_id = @parse_tree[:victim_id].to_i
    death_cause = @parse_tree[:death_cause].to_sym

    player = current_match.find_player_by_id(killer_id)
    player.add_kill(victim_id, death_cause)

    current_match
  end
end
