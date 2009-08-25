require 'singleton'

class CISignalHandler
  include Singleton
  
  def change_state(state_definition)
    ampel = Ampel.instance
    
    if state_definition[:ci]
      project = CIProject.new(state_definition["ci"])
      
      if project.is_broken? and was(project, :good)
        ampel.red "On"
        ampel.green "Off"
        ampel.signal 23
      end
      
      update_states_with project
      
      builds_in_progess? ? ampel.yellow("On") : ampel.yellow("Off")
      
      unless anything_is_broken?
        ampel.red "Off"
        ampel.green "On"
      end
    end
  end
  
  private
  
    def initialize
      @states = {}
      CIProject::VALID_STATES.each { |state| @states[state.to_sym] = {} }
    end
    
    def was(project, state)
      @states[state].has_key?(project.name) ? true : false
    end
    
    def update_states_with(project)
      if project.is_building?
        @states[:building][project.name] = project
      else
        @states[:building].delete(project.name) if was(project, :building)
      end
      
      if project.is_broken?
        @states[:good].delete(project.name)
        @states[:broken][project.name] = project
      elsif project.is_good?
        @states[:broken].delete(project.name)
        @states[:good][project.name] = project
      end
    end
    
    def builds_in_progess?
      @states[:building].size == 0 ? false : true
    end
    
    def anything_is_broken?
      @states[:broken].size == 0 ? false : true
    end
  
end