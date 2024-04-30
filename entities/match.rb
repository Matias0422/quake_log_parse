require './enumarators/death_cause_enum.rb'

class Match
  WORLD_PLAYER_ID = 1022
  WORLD_PLAYER_NAME = '<world>'

  @@counter = 0

  attr_accessor :index, :players

  def initialize
    @@counter += 1

    @index = @@counter
    @players = {}

    add_player(WORLD_PLAYER_ID, WORLD_PLAYER_NAME)
  end

  def add_player(player_id, name=nil)
    @players[player_id] = Player.new(id: player_id, name: name, match: self)
  end

  def find_player_by_id(player_id)
    @players[player_id]
  end

  def total_kills
    @players.sum { |_player_id, player_object| player_object.kills.size }
  end

  def player_names
    @players.map { |_player_id, player_object| player_object.name }
  end

  def players_name_and_kill_count
    @players.map { |_player_id, player_object| [player_object.name, player_object.kills_count] }
  end

  def players_name_and_kill_score
    @players.map { |_player_id, player_object| [player_object.name, player_object.kill_score] }
  end

  def ordered_players_name_and_kill_score
    players_name_and_kill_score.sort_by do |player_name_and_kill_score| 
      player_name_and_kill_score[1]
    end
  end

  def lost_score_by_victim_id(victim_id)
    world_player.kills_sum_by_victim_id(victim_id)
  end

  def kills_by_means
    death_cause_hash = DeathCauseEnum.new_hash_counter

    @players.
  end

  def world_player
    @world_player ||= find_player_by_id(WORLD_PLAYER_ID)
  end
end
