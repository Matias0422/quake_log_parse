require_relative '../reports_strategy.rb'

class MatchReportStrategy < ReportsStrategy

  def report_line!(match)
    print_hash(
      "game_#{match.index}".to_sym => {
        :total_kills => match.total_kills,
        :players => match.player_names,
        :kills => match.players_name_and_kill_count.to_h,
        :players_ranking => players_ranking_hash(match),
        :kills_by_means => match.kills_by_means
      }
    )
  end

  def players_ranking_hash(match)
    match.players_name_and_kill_score.sort_by do |player_name_and_kill_score| 
      -player_name_and_kill_score[1]
    end.to_h
  end
end
