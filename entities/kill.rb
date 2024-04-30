class Kill
  @@counter = 0

  attr_accessor :index, :victim_id, :death_cause, :player

  def initialize(victim_id:, death_cause:, player:)
    @@counter += 1

    @index = @@counter

    @victim_id = victim_id
    @death_cause = death_cause
    @player = player
  end
end
