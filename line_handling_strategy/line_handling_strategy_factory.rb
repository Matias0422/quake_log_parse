require_relative './strategies/init_game_line_strategy.rb'
require_relative './strategies/kill_line_strategy.rb'
require_relative './strategies/player_connect_line_strategy.rb'
require_relative './strategies/player_changed_line_strategy.rb'

class LineHandlingStrategyFactory
  HASH_FACTORY = {
    init_game_line: -> (parse_tree) { InitGameLineStrategy.new(parse_tree) }
    kill_line: -> (parse_tree) { KillLineStrategy.new(parse_tree) }
    player_connect_line: -> (parse_tree) { PlayerConnectLineStrategy.new(parse_tree) }
    player_changed_line: -> (parse_tree) { PlayerChangedLineStrategy.new(parse_tree) }
  }

  def self.create_strategy(parse_tree)
    strategy_key = parse_tree.keys.last

    if HASH_FACTORY.key?(strategy_key)
      HASH_FACTORY[:strategy_key].call(parse_tree[strategy_key])
    else
      raise ArgumentError, "Unsupported strategy key: #{strategy_key}"
    end
  end
end
