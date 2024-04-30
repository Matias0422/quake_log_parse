require_relative 'reports_base'

module MatchGroupedInformation < ReportsBase
  class Report
    def increment_line(match)
      new_line = "game_#{match.index}" => {
        "total_kills" => match.total_kills,
        "players" => match.player_names,
        "kills" => match.player_names_kill_count.to_h,
        "players_ranking" => match.ordered_players_name_and_kill_score
      }

      increment_json_line(JSON.dump(new_line))
    end
  end
end
