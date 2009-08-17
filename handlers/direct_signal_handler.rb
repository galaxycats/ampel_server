class DirectSignalHandler
  
  def change_state(state_definition)
    ampel = Ampel.instance
    
    unless state_definition["actions"].nil?
      state_definition["actions"].each do |color, state|
        ampel.send(color, state)
      end
    end
  end
  
end