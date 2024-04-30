require_relative 'kill'

class Player
  @@counter = 0

  attr_accessor :index, :id, :name, :kills, :kill_score, :match

  def initialize(id:, name: nil, match:)
    @@counter += 1

    @index = @@counter

    @id = id
    @match = match
    @name = name
  
    @kills = []
    @kill_score = 0
  end

  def add_kill(victim_id, death_cause)
    kill = Kill.new(victim_id: victim_id, death_cause: death_cause, player: self)

    @kills << kill

    compute_kill_score(kill)
    compute_kills_by_means(kill)
  end

  def increment_kill_score!
    self.kill_score += 1
  end

  def decrement_kill_score!
    self.kill_score -= 1
  end

  def world_player?
    id == match.world_player.id
  end

  def kill_count
    @kills.size
  end

  private

  def compute_kill_score(kill)
    return decrement_victim_kill_score(kill.victim_id) if world_player?

    increment_kill_score!
  end

  def compute_kills_by_means(kill)
    match.increment_kills_by_means(kill.death_cause)
  end

  def decrement_victim_kill_score(victim_id)
    player = match.find_player_by_id(victim_id)
    player.decrement_kill_score!
  end
end
