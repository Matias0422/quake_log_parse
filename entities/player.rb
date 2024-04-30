class Player
  @@counter = 0

  attr_accessor :index, :id, :name, :kills, :match

  def initialize(id:, name: nil, kills: [], match:)
    @@counter += 1

    @index = @@counter
    @id = id
    @name = name
    @kills = []
    @match = match
  end

  def add_kill(victim_id, death_cause)
    @kills << Kill.new(victim_id: victim_id, death_cause: death_cause)
  end

  def kill_sum_by_victim_id(victim_id)
    @kills.select { |kill| kill.victim_id == victim_id }.sum
  end

  # Memoization
  def kill_score
    @kill_score ||= kill_count - match.lost_score_by_victim_id(id)
  end

  def kill_count
    @kill_count ||= @kills.sum
  end
end
