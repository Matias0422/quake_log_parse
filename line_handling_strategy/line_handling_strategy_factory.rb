require_relative 'init_game_line_strategy'
require_relative 'kill_line_strategy'
require_relative 'player_connect_line_strategy'
require_relative 'player_changed_line_strategy'

class LineHandlingStrategyFactory
  def self.create_strategy(strategy_key)
    case strategy_key
    when :init_game_line
      return InitGameLineStrategy.new
    when :kill_line
      return KillLineStrategy.new
    when :player_connect_line
      return PlayerConnectLineStrategy.new
    when :player_changed_line
      return PlayerChangedLineStrategy.new
    else
      raise ArgumentError, "Unsupported strategy key: #{strategy_key}"
    end
  end
end
