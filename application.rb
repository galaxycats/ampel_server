require 'ampel'
require 'handlers'

class AmpelServer < Merb::Controller
  
  before :select_signal_handler
  before :load_ampel
  
  def _template_location(action, type = nil, controller = controller_name)
    controller == "layout" ? "layout.#{action}.#{type}" : "#{action}.#{type}"
  end

  def index
    render
  end
  
  def states
    render @ampel.state.join(";"), :layout => false
  end
  
  def change_state
    @handler.change_state(params)
    
    render :index
  end
  
  private
  
    def select_signal_handler
      @handler = if params["ci"]
        CISignalHandler.instance
      else
        DirectSignalHandler.new
      end
      Merb.logger.debug "Selected #{@handler.class.name} signal handler."
    end
    
    def load_ampel
      @ampel = Ampel.instance
    end
  
end