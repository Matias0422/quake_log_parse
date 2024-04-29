class Player
  @@counter = 0

  attr_accessor :index, :id, :name, :kills

  def initialize(id:, name: nil, kills: [])
    @@counter += 1

    @index = @@counter
    @id = id
    @name = name
    @kills = []
  end

  def add_kill(victim_id, death_cause)
    @kills << Kill.new(victim_id: victim_id, death_cause: death_cause)
  end
end
