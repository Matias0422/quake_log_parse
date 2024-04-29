class Kill
  @@counter = 0

  attr_accessor :index, :victim_id, :death_cause

  def initialize(victim_id:, death_cause:)
    @@counter += 1

    @index = @@counter
    @victim_id = victim_id
    @death_cause = death_cause
  end
end
