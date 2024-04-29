require './enumarators/death_cause_enum.rb'

class Match
  @@counter = 0

  WORLD_PLAYER_ID = 1022
  WORLD_PLAYER_NAME = '<world>'

  attr_accessor :index, :players

  def initialize
    @@counter += 1

    @index = @@counter
    @players = {}

    add_player(WORLD_PLAYER_ID, WORLD_PLAYER_NAME)
  end

  def world_player
    @world_player ||= find_player_by_id(WORLD_PLAYER_ID)
  end

  def add_player(player_id, name=nil)
    @players[player_id] = Player.new(id: player_id, name: name)
  end

  def find_player_by_id(player_id)
    @players[player_id]
  end

  def total_kills
    @players.sum { |player| player.kills.size }
  end

  def kills_by_means
    DeathCauseEnum.constants.map do |death_cause|
      [death_cause, 0]
    end.to_h
  end
end
