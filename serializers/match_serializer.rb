class MatchSerializer
  def self.hash_serialize(match)
    {
      total_kills: match.total_kills,
      players: match.players.map { |player| player[:name] },
      kills: match.players.map { |player| [player[:name].to_sym, player[:kills]] }.to_h,
      kills_by_means: match.kills_by_means
    }
  end
end
