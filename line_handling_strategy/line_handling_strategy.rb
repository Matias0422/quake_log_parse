class LineHandlingStrategy
  private_class_method :new

  def initialize(parse_tree)
    @parse_tree = parse_tree
  end

  def handle(_parse_tree, _current_match)
    raise NotImplementedError, "Implement this method in a subclass"
  end
end
