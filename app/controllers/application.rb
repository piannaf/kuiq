# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'b6b639fa2614e7bb19be59ab0d481a9b'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  include AuthenticatedSystem
  
  def video_exists?(id)
    response = Net::HTTP.get_response(URI.parse("http://gdata.youtube.com/feeds/api/videos/#{id}"))
    response.code.to_i == 200
  end
  
  #handle no route exists
  def method_missing(*args)
    rescue_404
  end
  
  def rescue_404
    @err_id = "bad route"
    respond_to do |type| 
      type.html { render :template => "errors/standard_404", :layout => 'application', :status => 404 } 
      type.all  { render :nothing => true, :status => 404 } 
    end
    
    true  # so we can do "render_404 and return"
  end
  
  #for seeing what everyone else sees
  #alias_method :rescue_action_locally, :rescue_action_in_public
  
end
