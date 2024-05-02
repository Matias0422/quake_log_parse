require 'parslet'

require './app/enumarators/death_cause_enum.rb'

class MatchLineParser < Parslet::Parser
  # Elements
  rule(:space)  { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:number) { match('[0-9]+').repeat(1) }
  rule(:timestamp) { number >> str(':') >> number }
  rule(:death_cause) { match('[' + DeathCauseEnum.constants.join('|') + ']').repeat(1) }

  # Lines
  rule(:init_game_line) {
    str('InitGame:')
  }
  rule(:shut_down_game_line) {
    str('ShutdownGame:')
  }
  rule(:player_connect_line) {
    str('ClientConnect:') >>
    space >>
    number.as(:player_id)
  }
  rule(:player_changed_line) {
    str('ClientUserinfoChanged: ') >>
    number.as(:player_id) >>
    str(' n\\') >>
    (str('\t').absent? >> any ).repeat.as(:player_name)
  }
  rule(:kill_line) {
    str('Kill: ') >>
    number.as(:killer_id) >>
    space >>
    number.as(:victim_id) >>
    space >>
    number >>
    str(': ') >>
    (str(' killed ').absent? >> any).repeat.as(:killer_name) >>
    str(' killed ') >>
    (str(' by ').absent? >> any).repeat.as(:victim_name) >>
    str(' by ') >>
    death_cause.as(:death_cause)
  }

  # Root
  rule(:default_beginning) { space? >> timestamp >> space }
  rule(:default_ending) { any.repeat.maybe }
  rule(:line) {
    default_beginning >>
    (
      init_game_line.as(:init_game_line) |
      shut_down_game_line.as(:shut_down_game_line) |
      player_connect_line.as(:player_connect_line) |
      player_changed_line.as(:player_changed_line) |
      kill_line.as(:kill_line)
    ) >>
    default_ending
  }
  root :line
end
