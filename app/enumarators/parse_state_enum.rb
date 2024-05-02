require_relative 'enum_base'

class ParseStateEnum
  extend EnumBase

  INITIALIZED = 'INITIALIZED'
  INCOMPLETE = 'INCOMPLETE'
  FINISHED = 'FINISHED'
end
