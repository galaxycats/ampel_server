require 'ampel'

class AmpelServer < Merb::Controller
  
  @@ampel = Ampel.new

  def _template_location(action, type = nil, controller = controller_name)
    controller == "layout" ? "layout.#{action}.#{type}" : "#{action}.#{type}"
  end

  def index
    unless params[:actions].nil?
      params[:actions].each do |color, state|
        @@ampel.send(color, state)
      end
    end
    
    @ampel = @@ampel
    
    render
  end
  
end