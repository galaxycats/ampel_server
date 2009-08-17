class CIProject
  
  VALID_STATES = %w(building broken good)
  
  attr_accessor :name
  attr_reader   :build_state
  
  def initialize(attributes)
    @name            = attributes["project_name"]
    self.build_state = attributes["build_state"]
  end
  
  def build_state=(build_state)
    @build_state = VALID_STATES.include?(build_state) ? build_state.to_sym : nil
  end
  
  VALID_STATES.each do |state|
    define_method("is_#{state}?") { @build_state == state.to_sym }
  end
  
end