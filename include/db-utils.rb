def load_in_db(list, type)
  num = 0
  beginning_time = Time.now
  list.each do |uid| 
    fof = getFof(uid)
    yield fof
    fof.save
    num = num + 1
  end
  end_time = Time.now
  $log.debug "#{num} #{type} loaded in #{(end_time - beginning_time)} seconds"
end