module EnumBase
  def new_hash_counter
    constants.map do |constant|
      [const_get(constant).to_sym, 0]
    end.sort.to_h
  end
end
