module ErrorsHelper
  
  def show_pretty_error(err_id, params = {})
    case err_id
    when "no such user"
      content_tag(:h2, "#{params[:user_id]} is not a valid user", :id => "page_title" ) +
      content_tag(:h4, "The profile you requested does not exist. " +
        link_to('Take a look at all <span class=\'kuiq\'>kuiq</span> users', users_path), :class => "error_message", :id => "under_title")
    when "bad route"
      content_tag(:h2, "#{request.path} is not a valid path", :id => "page_title" ) +
      content_tag(:h4, "The page you requested does not exist. " +
        link_to('Take a look at the <span class=\'kuiq\'>kuiq</span> homepage.', videos_path), :class => "error_message", :id => "under_title")
    when "no such video"
      content_tag(:h2, "#{params[:id]} is not a valid video ID", :id => "page_title" ) +
      content_tag(:h4, "The video you requested does not exist. " +
        link_to('Take a look at the <span class=\'kuiq\'>kuiq</span> homepage to see all our videos.', videos_path), :class => "error_message", :id => "under_title")
    end 
  end
end