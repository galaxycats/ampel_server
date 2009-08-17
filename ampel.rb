require 'singleton'
begin
  require 'simpleport'
rescue LoadError
  require 'spec/simpleport_mock'
end

class Ampel
  include Singleton
  
  SIGNAL = 2
  RED    = 7
  YELLOW = 3
  GREEN  = 4
  
  OFF = 0
  ON  = 1
  
  def initialize
    @handle = Simpleport.simpleport_open
    reset_lights
  end
  
  %w(red yellow green).each do |color|
    define_method(color) do |state|
      color_const = Ampel.const_get(color.upcase)
      
      if state == "Off"
        Simpleport.simpleport_set_pin(@handle, color_const, OFF)
      elsif state == "On"
        Simpleport.simpleport_set_pin(@handle, color_const, ON)
      end
      
      sleep(0.5)
    end
  end
  
  def state_for(color)
    Simpleport.simpleport_get_pin(@handle, Ampel.const_get(color.upcase)) == 0 ? "Off" : "On"
  end
  
  def state
    states = %w(red yellow green signal).inject([]) do |state, color|
      state << "#{color}=#{state_for(color)}"
    end
    return states
  end
  
  def signal(duration=10)
    if duration.to_i > 0
      Simpleport.simpleport_set_pin(@handle, SIGNAL, ON)
      sleep(duration.to_i)
      Simpleport.simpleport_set_pin(@handle, SIGNAL, OFF)
    elsif duration == "Off"
      Simpleport.simpleport_set_pin(@handle, SIGNAL, OFF)
    elsif duration == "On"
      Simpleport.simpleport_set_pin(@handle, SIGNAL, ON)
    end
  end
  
  private
  
    def reset_lights
      for i in 1..11 do
        Simpleport.simpleport_set_pin(@handle, i, OFF)
      end
    end
  
end