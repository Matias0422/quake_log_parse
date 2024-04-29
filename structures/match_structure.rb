require './enumarators/death_cause_enum.rb'


# PASSAR PLAYERS PARA OUTRA ESTRUTURA E CONSIDERAR O WORLD COMO UM PLAYER <<<<<<<<<<<<<

class MatchStructure
  attr_accessor :total_kills, :players, :kills_by_means

  def initialize
    @total_kills = 0
    @players = {}
    @kills_by_means = DeathCauseEnum.constants.map do |death_cause|
      [death_cause, 0]
    end.to_h
  end

  def add_player(player_id, name)
    @players[player_id] = { name: name, kills: 0 }
  end

  def increment_kills(player_id)
    @players[player_id][:kills] += 1 if @players.key?(player_id)
  end

  def decrement_kills(player_id)
    @players[player_id][:kills] -= 1 if @players.key?(player_id)
  end

  def add_kill_by_means(death_cause)
    @kills_by_means[death_cause] += 1 if @kills_by_means.key?(death_cause)
  end
end
