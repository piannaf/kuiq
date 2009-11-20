class ProfilesController < ApplicationController
  rescue_from NoMethodError, :with => :show_error
  #rescue_from ActiveResource::BadRequest, :with => :go_to_first_page
  
  def show
    @user = User.find_by_login(params[:user_id])
    
    #get thumnails
    @max_results = 10
    
    client = YouTubeG::Client.new
    @ytg_result = client.videos_by(:developer_tags => "kuiqtest_#{params[:user_id]}", :page => params[:page], :max_results => @max_results, :headers => {"X-GData-Key" => "key=AI39si4PHm-0wUtYO6jVx-ywH23zI93R8nLY24NJrCUn27FCuTESwIWH1I5wQE-vj1vGXHtid9zeXWR4vmv9bw7RdvZcpqCjXg"})
    #@ytg_result = client.videos_by(:user => "failblog", :page => params[:page], :max_results => @max_results, :headers => {"X-GData-Key" => "key=AI39si4PHm-0wUtYO6jVx-ywH23zI93R8nLY24NJrCUn27FCuTESwIWH1I5wQE-vj1vGXHtid9zeXWR4vmv9bw7RdvZcpqCjXg"})
    @ytg_videos = @ytg_result.videos.reverse
    
    #initialize useful variables
    @total = @ytg_result.total_result_count     
    @current_page = @ytg_result.current_page
    @number_of_pages = @ytg_result.total_pages
            
    @vidvatar = @user.profile.vidvatar =~ /^[a-zA-Z0-9_-]{11}$/ && video_exists?(@user.profile.vidvatar) ? client.video_by(@user.profile.vidvatar) : client.video_by('T6LxtUgzVjk')
    
    flash[:warning] = "Videos must be indexed by Google before appearing in your profile." if request.referer =~ /videos\/new$/
    
  end
  
  def edit
    @profile = current_user.profile if logged_in?
  end
  
  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:profile])
        flash[:notice] = "Profile was successfully updated."
        redirect_to(user_profile_url(current_user))
    else
        render :action => 'edit'
    end
  end
  
  private
  
  def go_to_first_page
    redirect_to user_profile_url(params[:user_id], :page => 1)
  
    true  # so we can do "show_error and return"
  end
  
  def show_error
    @err_id = "no such user"
    respond_to do |type| 
      type.html { render :template => "errors/standard_404", :layout => 'application', :status => 404 } 
      type.all  { render :nothing => true, :status => 404 } 
    end
    
    true  # so we can do "show_error and return"
  end
      
end
