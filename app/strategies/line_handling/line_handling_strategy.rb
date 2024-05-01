module LineHandlingStrategy

  def initialize(parse_tree)
    @parse_tree = parse_tree
  end

  def handle(parse_tree, current_match)
    raise NotImplementedError, "Implement this method in a subclass"
  end
end
