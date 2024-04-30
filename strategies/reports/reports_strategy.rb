require 'awesome_print'

class ReportsStrategy

  def print_hash(hash)
    ap(hash)
  end

  def report_line(*args)
    raise NotImplementedError, "Implement this method in a subclass"
  end
end
