class VideosController < ApplicationController
  include YouTubeModel::Helpers
  
  rescue_from OpenURI::HTTPError, :with => :show_error
  rescue_from YouTubeG::Upload::UploadError, :with => :upload_error
  
  # GET /videos
  # GET /videos.xml
  def index
    @max_results = 5
        
    @ytg_result = YouTubeG::Client.new.videos_by(:developer_tags => [:kuiqtest], :page => params[:page], :max_results => @max_results, :headers => {"X-GData-Key" => "key=AI39si4PHm-0wUtYO6jVx-ywH23zI93R8nLY24NJrCUn27FCuTESwIWH1I5wQE-vj1vGXHtid9zeXWR4vmv9bw7RdvZcpqCjXg"})
    #@ytg_result = client.videos_by(:user => 'failblog', :page => params[:page], :max_results => @max_results, :headers => {"X-GData-Key" => "key=AI39si4PHm-0wUtYO6jVx-ywH23zI93R8nLY24NJrCUn27FCuTESwIWH1I5wQE-vj1vGXHtid9zeXWR4vmv9bw7RdvZcpqCjXg"})
    @ytg_videos = @ytg_result.videos.reverse
    
    @current_page = @ytg_result.current_page
    @number_of_pages = @ytg_result.total_pages
    @total = @ytg_result.total_result_count

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @result }
    end
  end

  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = YouTubeG::Client.new.video_by(params[:id], :headers => {"X-GData-Key" => "key=AI39si4PHm-0wUtYO6jVx-ywH23zI93R8nLY24NJrCUn27FCuTESwIWH1I5wQE-vj1vGXHtid9zeXWR4vmv9bw7RdvZcpqCjXg"})

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @youtube }
    end
  end

  # GET /videos/new
  # GET /videos/new.xml
  def new
    @categories ||= Video.categories_collection
      params[:video] ||= {}
  end

  # GET /videos/1/edit
  def edit
    @categories ||= Video.categories_collection
  end
  
  # POST /videos
  # POST /videos.xml
  def create      
  	if params[:yt_login].blank? || params[:yt_password].blank? || params[:video][:title].blank? || params[:video][:description].blank? || params[:video][:keywords].blank? || params[:video][:file].blank?
  	  flash[:warning] = "Your upload failed because you forgot:<br />"
  	  
  	  flash[:warning] << "&nbsp;&nbsp;&nbsp;&nbsp;YouTube ID<br />" if params[:yt_login].blank?
      flash[:warning] << "&nbsp;&nbsp;&nbsp;&nbsp;YouTube Password<br />" if params[:yt_password].blank?
    	flash[:warning] << "&nbsp;&nbsp;&nbsp;&nbsp;a title<br />" if params[:video][:title].blank?
      flash[:warning] << "&nbsp;&nbsp;&nbsp;&nbsp;a description<br />" if params[:video][:description].blank?
      flash[:warning] << "&nbsp;&nbsp;&nbsp;&nbsp;at least one keyword<br />" if params[:video][:keywords].blank?
      flash[:warning] << "&nbsp;&nbsp;&nbsp;&nbsp;a video<br />" if params[:video][:file].blank?
      flash[:warning] << "Note: You must choose a file again"
      
      @categories ||= Video.categories_collection
      
      render :action => "new"
      #redirect_to(new_video_url)
    else
      @uploader = YouTubeG::Upload::VideoUpload.new(params[:yt_login], params[:yt_password], "AI39si4PHm-0wUtYO6jVx-ywH23zI93R8nLY24NJrCUn27FCuTESwIWH1I5wQE-vj1vGXHtid9zeXWR4vmv9bw7RdvZcpqCjXg")

      @file = params[:video][:file]
      @status = @uploader.upload File.open(@file.path), #NOTE status returns the ID of the unpublished video
        :title => params[:video][:title],
        :description => params[:video][:description],
        :category => params[:video][:category],
        :keywords => params[:video][:keywords].split(/\W+/),
        :developer_tags => ["kuiqtest", "kuiqtest_#{current_user.login}"]
        
      redirect_to(user_profile_url(current_user))
	  end

  end

  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    # @youtube = Video.find(params[:id])
    # 
    # respond_to do |format|
    #   if @youtube.update_attributes(params[:attr_type])
    #     flash[:notice] = 'Video was successfully updated.'
    #     format.html { redirect_to(@youtube) }
    #     format.xml  { head :ok }
    #   else
    #     format.html { render :action => "edit" }
    #     format.xml  { render :xml => @youtube.errors, :status => :unprocessable_entity }
    #   end
    # end
  end
  
  # GET /videos/1/delete
  def delete
    # @youtube = Video.find( params[:id] )
    # respond_to do |format|
    #     format.html # delete.html.erb
    # end
  end

  # DELETE /videos/1
  # DELETE /videos/1.xml
  def destroy
    # @youtube = Video.find(params[:id])
    # redirect_to(@youtube) and return if params[:cancel]
    # 
    # respond_to do |format|
    # 	if @youtube.destroy
    # 		flash[:notice] = 'Type was successfully destroyed.'
    #   	format.html { redirect_to(videos_url) }
    #   	format.xml  { head :ok }
    # 	else
    # 		flash[:notice] = 'Type was NOT destroyed.'
    # 		format.html { render :action => "delete"}
    # 		format.xml  { render :xml => @youtube.errors, :status => :unprocessable_entity }
    #   		end
    # end
  end
  
  protected
  
  def show_error
    @err_id = "no such video"
    
    respond_to do |type| 
      type.html { render :template => "errors/standard_404", :layout => 'application', :status => 404 } 
      type.all  { render :nothing => true, :status => 404 } 
    end
    
    true  # so we can do "show_error and return"
  end
  
  def upload_error
    flash[:warning] = "Your upload failed because your YouTube information was incorrect.<br />"
    redirect_to(new_video_url)

    true
  end
  
end
