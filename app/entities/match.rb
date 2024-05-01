require './app/enumarators/death_cause_enum.rb'
require './app/enumarators/parse_state_enum.rb'

require_relative 'player'

class Match
  WORLD_PLAYER_ID = 1022

  @@counter = 0

  attr_accessor :index, :players, :parse_state, :total_kills, :kills_by_means

  def initialize
    @@counter += 1

    @index = @@counter

    @players = {}
    @parse_state = nil
    @kills_by_means = DeathCauseEnum.new_hash_counter
    @total_kills = 0

    add_player(WORLD_PLAYER_ID)
  end

  def add_player(player_id)
    @players[player_id] ||= Player.new(id: player_id, match: self)
  end

  def find_player_by_id(player_id)
    @players[player_id]
  end

  def parse_initialize!
    self.parse_state = ParseStateEnum::INITIALIZED
  end

  def parse_finalize!
    self.parse_state = ParseStateEnum::FINISHED
  end

  def parse_initialized?
    parse_state == ParseStateEnum::INITIALIZED
  end

  def parse_finished?
    parse_state == ParseStateEnum::FINISHED
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

  def players_ranking
    players_name_and_kill_score.sort_by do |player_name_and_kill_score| 
      -player_name_and_kill_score[1]
    end.to_h
  end

  def increment_total_kills!
    self.total_kills += 1
  end

  def increment_kills_by_means!(death_cause)
    death_cause_key = death_cause.to_sym

    self.kills_by_means[death_cause_key] ||= 0 
    self.kills_by_means[death_cause_key] += 1
  end

  def world_player
    @world_player ||= find_player_by_id(WORLD_PLAYER_ID)
  end
end
