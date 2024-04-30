require './app/enumarators/death_cause_enum.rb'

require_relative 'player'

class Match
  WORLD_PLAYER_ID = 1022
  WORLD_PLAYER_NAME = '<world>'

  @@counter = 0

  attr_accessor :index, :players, :kills_by_means

  def initialize
    @@counter += 1

    @index = @@counter

    @players = {}
    @kills_by_means = DeathCauseEnum.new_hash_counter

    add_player(WORLD_PLAYER_ID, WORLD_PLAYER_NAME)
  end

  def add_player(player_id, name=nil)
    @players[player_id] ||= Player.new(id: player_id, name: name, match: self)
  end

  def find_player_by_id(player_id)
    @players[player_id]
  end

  def total_kills
    @players.sum { |_player_id, player_object| player_object.kills.size }
  end

  def player_names
    map_players_without_world_player { |_player_id, player_object| player_object.name }
  end

  def players_name_and_kill_count
    map_players_without_world_player { |_player_id, player_object| [player_object.name.to_sym, player_object.kill_count] }
  end

  def players_name_and_kill_score
    map_players_without_world_player { |_player_id, player_object| [player_object.name.to_sym, player_object.kill_score] }
  end

  def map_players_without_world_player
    list = []

    @players.each do |player_id, player_object|
      next if player_id == world_player.id

      list << yield(player_id, player_object)
    end

    list
  end

  def increment_kills_by_means(death_cause)
    death_cause_key = death_cause.to_sym

    self.kills_by_means[death_cause_key] ||= 0 
    self.kills_by_means[death_cause_key] += 1
  end

  def world_player
    @world_player ||= find_player_by_id(WORLD_PLAYER_ID)
  end
end
