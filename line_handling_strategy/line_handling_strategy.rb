module LineHandlingStrategy
  def handle(parse_tree, current_match)
    raise NotImplementedError, "Implement this method in a subclass"
  end
end
