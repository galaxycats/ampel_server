class Simpleport
  
  @@pins = {
    1  => 0,
    2  => 0,
    3  => 0,
    4  => 0,
    5  => 0,
    6  => 0,
    7  => 0,
    8  => 0,
    9  => 0,
    10 => 0,
    11 => 0
  }
  
  def self.simpleport_open
    Merb.logger.debug "Simpleport mock handle was created."
    "handle_mock"
  end
  
  def self.simpleport_set_pin(handle, pin, value)
    Merb.logger.debug "Setting pin #{pin} to value #{value}."
    @@pins[pin] = value
  end
  
  def self.simpleport_get_pin(handle, pin)
    Merb.logger.debug "Value of pin #{pin} is #{@@pins[pin]}."
    @@pins[pin]
  end
  
end