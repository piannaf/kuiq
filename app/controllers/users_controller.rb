class UsersController < ApplicationController 
  
  #render index.rhtml
  def index
    @max_results = 20
    @users = User.paginate :page => params[:page], :per_page => @max_results, :order => 'login DESC'
    @total_users = User.find(:all).size
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  def show
    redirect_to(user_profile_url(params[:id]))
  end
  
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    

    
    #save the user
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

end
