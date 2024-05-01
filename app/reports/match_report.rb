require 'awesome_print'

class MatchReport

  def print!(match)
    ap(
      "game_#{match.index}".to_sym => {
        :total_kills => match.total_kills,
        :players => match.player_names,
        :kills => match.players_name_and_kill_count.to_h,
        :players_ranking => match.players_ranking.to_h,
        :kills_by_means => match.kills_by_means
      }
    )
  end
end
